
#include "stream.h"

#include "gtest/gtest.h"
#include "test_util/stream.h"

namespace cheaproute {

static void TestCharacterByCharacter(size_t max_read_size, size_t buffer_size) {
  BufferedInputStream stream(shared_ptr<InputStream>(
    new FakeInputStream(max_read_size, "Hello World!")), buffer_size);
  
  ASSERT_EQ('H', stream.Peek());
  ASSERT_EQ('H', stream.Read());
  ASSERT_EQ('e', stream.Read());
  ASSERT_EQ('l', stream.Read());
  ASSERT_EQ('l', stream.Read());
  ASSERT_EQ('o', stream.Read());
  ASSERT_EQ(' ', stream.Read());
  ASSERT_EQ('W', stream.Peek());
  ASSERT_EQ('W', stream.Peek());
  ASSERT_EQ('W', stream.Read());
  ASSERT_EQ('o', stream.Read());
  ASSERT_EQ('r', stream.Read());
  ASSERT_EQ('l', stream.Read());
  ASSERT_EQ('d', stream.Read());
  ASSERT_EQ('!', stream.Read());
  ASSERT_EQ(-1, stream.Read());
  ASSERT_EQ(-1, stream.Read());
  ASSERT_EQ(-1, stream.Read());
  ASSERT_EQ(-1, stream.Peek());
}

TEST(BufferedInputStreamTest, CharacterByCharacterReading) {
  TestCharacterByCharacter(100, 4);
  TestCharacterByCharacter(6, 4);
  TestCharacterByCharacter(3, 4);
  TestCharacterByCharacter(2, 4);
  TestCharacterByCharacter(1, 4);
  TestCharacterByCharacter(2, 100);
  TestCharacterByCharacter(100, 100);
}

static string ReadString(InputStream* stream, size_t size) {
  vector<char> buffer;
  buffer.resize(size);
  size_t bytes_read = stream->Read(&buffer[0], size);
  assert(bytes_read >= 0);
  assert(bytes_read <= size);
  return string(&buffer[0], bytes_read);
}

TEST(BufferedInputStreamTest, NormalReading) {
  BufferedInputStream stream(shared_ptr<InputStream>(
    new FakeInputStream(6, "Hello World!")), 4);
  
  ASSERT_EQ("Hello ", ReadString(&stream, 6));
  ASSERT_EQ("W", ReadString(&stream, 1));
  ASSERT_EQ("orl", ReadString(&stream, 10));
  ASSERT_EQ("d!", ReadString(&stream, 10));
  ASSERT_EQ("", ReadString(&stream, 10));
}

TEST(BufferedOutputStreamTest, CharacterByCharacterWriting) {
  MemoryOutputStream* memOutStream = new MemoryOutputStream();
  BufferedOutputStream stream(shared_ptr<OutputStream>(memOutStream), 5);
  stream.Write('a');
  stream.Write('b');
  stream.Write('c');
  stream.Write('d');
  stream.Write('e');
  stream.Write('f');
  stream.Write('g');
  stream.Flush();
  AssertStreamContents("abcdefg", memOutStream);
}

TEST(BufferedOutputStreamTest, SmallWrites) {
  MemoryOutputStream* memOutStream = new MemoryOutputStream();
  BufferedOutputStream stream(shared_ptr<OutputStream>(memOutStream), 5);
  stream.Write("ab", 2);
  stream.Write("cd", 2);
  stream.Write("ef", 2);
  stream.Write("gh", 2);
  stream.Flush();
  AssertStreamContents("abcdefgh", memOutStream);
}

TEST(BufferedOutputStreamTest, SmallWriteThenBigWrite) {
  MemoryOutputStream* memOutStream = new MemoryOutputStream();
  BufferedOutputStream stream(shared_ptr<OutputStream>(memOutStream), 5);
  stream.Write("ab", 2);
  stream.Write("cdefghijkl", 10);
  stream.Flush();
  AssertStreamContents("abcdefghijkl", memOutStream);
}

}