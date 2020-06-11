require 'spec_helper'

describe PrimeTime::Calculate do
  
  describe ".is_prime?" do
    it "can detect if a number is prime" do
      expect(PrimeTime::Calculate.is_prime?(2)).to be true
      expect(PrimeTime::Calculate.is_prime?(3)).to be true
      expect(PrimeTime::Calculate.is_prime?(5)).to be true
      expect(PrimeTime::Calculate.is_prime?(7)).to be true
      expect(PrimeTime::Calculate.is_prime?(11)).to be true
      expect(PrimeTime::Calculate.is_prime?(13)).to be true
      expect(PrimeTime::Calculate.is_prime?(17)).to be true
      expect(PrimeTime::Calculate.is_prime?(19)).to be true
      expect(PrimeTime::Calculate.is_prime?(23)).to be true
      expect(PrimeTime::Calculate.is_prime?(29)).to be true
      expect(PrimeTime::Calculate.is_prime?(71)).to be true
      expect(PrimeTime::Calculate.is_prime?(113)).to be true
      expect(PrimeTime::Calculate.is_prime?(173)).to be true
      expect(PrimeTime::Calculate.is_prime?(229)).to be true
      expect(PrimeTime::Calculate.is_prime?(281)).to be true
      expect(PrimeTime::Calculate.is_prime?(349)).to be true
      expect(PrimeTime::Calculate.is_prime?(409)).to be true
      expect(PrimeTime::Calculate.is_prime?(7919)).to be true
      expect(PrimeTime::Calculate.is_prime?(99971)).to be true
      expect(PrimeTime::Calculate.is_prime?(104729)).to be true
    end

    it "can detect if a number is not prime" do
      expect(PrimeTime::Calculate.is_prime?(-7919)).to be false
      expect(PrimeTime::Calculate.is_prime?(-1009)).to be false
      expect(PrimeTime::Calculate.is_prime?(-3)).to be false
      expect(PrimeTime::Calculate.is_prime?(-2)).to be false
      expect(PrimeTime::Calculate.is_prime?(-1)).to be false
      expect(PrimeTime::Calculate.is_prime?(0)).to be false
      expect(PrimeTime::Calculate.is_prime?(1)).to be false
      expect(PrimeTime::Calculate.is_prime?(4)).to be false
      expect(PrimeTime::Calculate.is_prime?(10)).to be false
      expect(PrimeTime::Calculate.is_prime?(49)).to be false
      expect(PrimeTime::Calculate.is_prime?(50)).to be false
      expect(PrimeTime::Calculate.is_prime?(100)).to be false
      expect(PrimeTime::Calculate.is_prime?(121)).to be false
      expect(PrimeTime::Calculate.is_prime?(169)).to be false
      expect(PrimeTime::Calculate.is_prime?(534535)).to be false
      expect(PrimeTime::Calculate.is_prime?(3424235)).to be false
      expect(PrimeTime::Calculate.is_prime?(23434349)).to be false
      expect(PrimeTime::Calculate.is_prime?(100000001)).to be false
    end
  end

  describe ".primes" do
    it "returns a list of the first n primes" do
      expect(PrimeTime::Calculate.primes(0)).to eq []
      expect(PrimeTime::Calculate.primes(1)).to eq [2]
      expect(PrimeTime::Calculate.primes(2)).to eq [2, 3]
      expect(PrimeTime::Calculate.primes(5)).to eq [2, 3, 5, 7, 11] 
      expect(PrimeTime::Calculate.primes(10)).to eq [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
      expect(PrimeTime::Calculate.primes(20)).to eq [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71]
      expect(PrimeTime::Calculate.primes(100)).to eq [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541]
    end
  end

end