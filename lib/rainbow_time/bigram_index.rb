require 'damerau-levenshtein'

class BigramIndex
  def initialize
    @index = {}
  end

  def save(path)
    File.open(path, 'w') {|f| f.write(Marshal.dump(@index))}
  end

  def load(path)
    data = File.read(path)
    @index = Marshal.load(data)
  end

  def add_metadata(id, data = {})
    @index[:metadata] ||= {}
    @index[:metadata][id] ||= {}
    @index[:metadata][id].merge!(data)
  end

  def get_metadata(id)
    data = @index[:metadata] || {}
    data[id] || {}
  end

  def index_item_titles(id, titles, metadata)
    add_metadata(id, metadata)
    word_sets = []
    # permutate into titles with apostrophes cut if possible
    titles.each do |title|
      words = sanitize_string(title).split(/\s+/)
      scrubbed_words = words.map {|w| touchup_string(w)}
      
      word_sets << words
      word_sets << scrubbed_words if scrubbed_words != words
    end

    # remove accidental duplicates
    word_sets.uniq!

    # save and index sentences
    @index[:titles] ||= {}
    @index[:titles][id] = []
    word_sets.each_with_index do |words, sub_id|
      @index[:titles][id] << words.join(' ')
      index_bigrams(id, sub_id, words)
    end
  end

  def index_bigrams(id, sub_id, words)
    @index[:bigrams] ||= {}
    bigrams(words).each do |bigram|
      @index[:bigrams][bigram] ||= []
      @index[:bigrams][bigram] << [id, sub_id]
    end
  end


  def find(query_title, metadata_hint_key = nil, metadata_hint_value = nil)
    words = sanitize_string(query_title).split(/\s+/)

    bigram_hits = Hash.new(0)
    bigrams(words).each do |bigram|
      title_keys = @index[:bigrams][bigram] || []
      title_keys.each do |key|
        bigram_hits[key] += 1
      end
    end

    if metadata_hint_key
      bigram_hits.delete_if do |key, count|
        id, sub_id = *key
        get_metadata(id)[metadata_hint_key] != metadata_hint_value
      end
    end

    # converts hash to array
    bigram_hits = bigram_hits.sort {|m1, m2| m1.last <=> m2.last}
    bigram_hits.reverse!
    # if no clear winner
    if bigram_hits.count > 1 && bigram_hits[0].last == bigram_hits[1].last
      sort_bigram_results_by_edit_distance(bigram_hits, words.join(' '))
    end

    best_result = bigram_hits.first
    return nil unless best_result
    
    key = best_result.first
    id, sub_id = *key
    title = @index[:titles][id][sub_id]

    score = best_result.last
    puts "FOUND #{score}: #{title} #{key.inspect}"
    id
  end

  private

  def sort_bigram_results_by_edit_distance(results, query_title)
    # delete any with worse score than highest score
    results.delete_if {|match| match.last != results[0].last}

    results.each do |result|
      key = result[0]
      id, sub_id = *key

      title = @index[:titles][id][sub_id]
      puts "#{title}: #{DamerauLevenshtein.distance(title, query_title)}"
      # set score based on edit distance
      # edit distance of 0 means same string and higher edit scores = less similarity
      result[1] = 1000 - DamerauLevenshtein.distance(title, query_title)
    end

    # resort so highest score (best score) goes first
    results.sort {|m1, m2| m2.last <=> m1.last}
  end

  def bigrams(words)
    words = [nil] + words + [nil]
    words.each_cons(2).to_a
  end

  def sanitize_string(str)
    str = str.downcase
    str.gsub!("’", "'")
    str.gsub!(/[“”]/, '"')
    str.gsub!("×", "x")
    str.gsub!(/\s+/,' ')
    str.strip!
    str
  end

  def touchup_string(word)
    word = word.gsub(/'s$/, 's')
    word.gsub!(/'/, ' ')
    word.gsub!(/:/, '')
    word
  end
end
