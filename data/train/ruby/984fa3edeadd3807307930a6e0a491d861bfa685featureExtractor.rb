# -*- coding: utf-8 -*-
#テキストの列の受け取り、解析して、そのテキスト内の名詞を保持する
class FeatureExtractor
  attr_reader :textID, :knpLines, :nounList
  NounListDir='./nounLists/'

  def initialize(textID, knpLines)
    @textID=textID
    @knpLines=knpLines
    @nounList=extractNoun(@knpLines)
  end

  def extractFeature
    #TODO
  end

  def extractNoun(knpLines)
    ans=[]
    knpLines.each do |line|

      #文節行
      if /^[\+\*]\s/ =~ line
        
        #品詞が曖昧
      elsif /品曖/ =~ line
        
      elsif  /人名/ =~ line
        ans << ((line.split(" ")[2]) + ":人名")
      elsif (/普通名詞/ =~ line) || (/固有名詞/ =~ line)
        if /カテゴリ:人[\"\s]/ =~ line
          ans << ((line.split(" ")[2]) + ":人")
        elsif /カテゴリ:動物[\"\s]/ =~ line
          ans << ((line.split(" ")[2]) + ":動物")
        end
      end
    end #end of block
    return ans
  end

  def getCallFeature(noun, knpLines = @knpLines)
    chunks = getAstChunks(noun)
    ans = chunks.find_all {|chunk| /<係:ト格>/ =~ chunk}.map {|chunk| getModifiee(chunk)}.find_all{|chunk| not chunk.nil?}.find_all {|chunk| /正規化代表表記:言う\/いう/ =~ chunk}.map {|chunk| getModifiee(chunk)}.find_all{|chunk| not chunk.nil?}.map {|chunk| getNormalizedForm(chunk)}.map {|nForm| mergeNormalizedForm(nForm)}



    return ans.map{|str| "call:" + str}
  end
  
  def getCfFeature(noun, knpLines = @knpLines)
    #return ["cf:歩く:動:ガ格"]

    declinableChunks = getPlusChunks(noun).map {|chunk| getModifiee(chunk)}.find_all{|chunk| not chunk.nil?}.find_all {|chunk| /<用言:.*?>/ =~ chunk}

    ans = declinableChunks.map{|chunk| "cf:" + getHyouki(getNormalizedForm(chunk)) + ":" + getDeclinableType(chunk) + ":" + getCfType(chunk, noun) + "格"}

    return ans
  end

def getDemoFeature(noun, knpLines = @knpLines)
# a = getPlusChunks(noun).map{|chunk| getModifier(chunk)}.flatten.find_all{|chunk| /<連体修飾>/ =~ chunk}

# #この
# #これらの

# return ["demo:この"]
end

def getSufFeature(noun, knpLines = @knpLines)

#最初のindexしか得られないので注意
wordChunks = getWordChunks(knpLines)
index = wordChunks.find_index{|chunk| /^#{noun}/ =~ chunk}
  if index + 1 < wordChunks.length
    chunk = wordChunks[index + 1]
    if /名詞性名詞接尾辞/ =~ chunk
      return ["suf:" + chunk.split(" ")[2]]
    end
  else
    return []
  end

end

def getNcf1Feature(noun, knpLines = @knpLines)
  ans = getAstChunks(noun).find_all{|chunk| /<係:ノ格>/ =~ chunk}.map{|chunk| getModifiee(chunk)}.find_all{|chunk| not chunk.nil?}.map {|chunk| getNormalizedForm(chunk)}.map {|nForm| mergeNormalizedForm(nForm)}.map {|str| "ncf1:" + str}

return ans
end

def getNcf2Feature(noun, knpLines = @knpLines)
  ans = getAstChunks(noun).map{|chunk| getModifier(chunk)}.flatten.find_all{|chunk| not chunk.nil?}.find_all{|chunk| /<係:ノ格>/ =~ chunk}.map {|chunk| getNormalizedForm(chunk)}.map {|nForm| mergeNormalizedForm(nForm)}.map {|str| "ncf2:" + str}

return ans
end


  def getModifier(chunk, knpLines = @knpLines)
    chunk_array=getChunkArray(chunk)
    modifieeIndex = chunk_array.index(chunk)

    ans = []
    chunk_array.each do |chunk1|
      if getModifieeIndex(chunk1) == modifieeIndex
        ans << chunk1 
      end
    end

    if ans == []
      return nil
    else
      return ans
    end

  end


  def getModifiee(chunk, knpLines = @knpLines)
    chunk_array=getChunkArray(chunk, knpLines)

    modifieeIndex = getModifieeIndex(chunk)
    if modifieeIndex==-1
      return nil
    else
      return chunk_array[modifieeIndex]
    end

  end


  #nounが含まれている*チャンク(複数の可能性あり)を返す
  def getAstChunks(noun, knpLines = @knpLines)
    return getChunks(noun, '*', knpLines)
  end

  #nounが含まれている+チャンク(複数の可能性あり)を返す
  def getPlusChunks(noun, knpLines = @knpLines)
    return getChunks(noun, '+', knpLines)
  end

  def getChunks(noun, ch, knpLines = @knpLines)
    ans = []
    tmpChunk = ""

    knpLines.each do |line|
      if /^#{Regexp.escape(ch)}\s/ =~ line
        tmpChunk = line
      elsif /^#{Regexp.escape(noun)}\s/ =~ line
        ans << tmpChunk
      end
    end

    return ans
  end
  protected :getChunks
  

  def getChunkArray(chunk, knpLines = @knpLines)
    ans=[]
    if /^\+/ =~ chunk
      ans = knpLines.find_all {|line| /^\+/ =~ line}
    elsif /^\*/ =~ chunk
      ans = knpLines.find_all {|line| /^\*/ =~ line}
    end

    return ans
  end

end

def getModifieeIndex(chunk) 
  if /^[\+\*]\s(.*)[DPIA]/ =~ chunk
    return $1.to_i
  else
    raise "modifieeIndex error (featureExtractor.rb L:#{__LINE__})"
  end
end

#チャンクの正規化代表表記を返す
def getNormalizedForm(chunk)
  ans = nil
  if /<正規化代表表記:(.*?)>/ =~ chunk
    ans = $1
  end
  return ans
end

def mergeNormalizedForm(nForm)
  if nForm.include?("?")
    forms = nForm.split("?")

    hyoukiArray = forms.map {|form| getHyouki(form)}.uniq
    yomiArray = forms.map {|form| getYomi(form)}.uniq

    if hyoukiArray.length == 1
      return hyoukiArray[0]
    elsif yomiArray.length == 1
      return yomiArray[0]
    else
      raise "ERROR: #{__LINE__}"
    end
  else
#曖昧性が無い場合は、「表記」を返す
    return getHyouki(nForm)
  end
end

def getHyouki(str)
  if str.include?("/")
    return str.split("/")[0]
  else 
    raise "ERROR: #{__LINE__}"
  end
end


def getYomi(str)
  if str.include?("/")
    return str.split("/")[1]
  else 
    raise "ERROR: #{__LINE__}"
  end
end

def getDeclinableType(chunk)
  if /<用言:(.*?)>/ =~ chunk
    return $1
  else
    return nil
  end
end

def getCfType(chunk, noun)
  if /<格解析結果:.*[;:](.*?)\/[C]\/太郎/u =~ chunk
    return $1
  else
    return nil
  end
end


def getWordChunks(chunk)
return chunk.find_all{|chunk| not (/^[\*\+]/ =~ chunk)}
end

