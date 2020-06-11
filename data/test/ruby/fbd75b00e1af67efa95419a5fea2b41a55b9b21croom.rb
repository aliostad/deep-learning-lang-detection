class Room < ActiveRecord::Base
  SIDE_SIZE = 3
  def acquireBox (locationY,locationX,player)
    position = calculateStringIndex_s( locationY, locationX)

    newBoxVal = box.clone
    newBoxVal[position] = player
    update_attribute(:box, newBoxVal)
  end

  def boxStatus(y,x)
    position = calculateStringIndex(y,x)
    return charAt(box,position)
  end

  def isBoxAcquired?(y,x)
    position = calculateStringIndex(y,x)
    return charAt(box,position).eql?("0")
  end

  def charAt(string, index)
    return string[index..index]
  end

  def calculateStringIndex(positionY, positionX)
    return positionY * SIDE_SIZE + positionX
  end

  def calculateStringIndex_s(locationY, locationX)
    x = Integer(locationX)
    y = Integer(locationY)
    return calculateStringIndex(y,x)
  end
end
