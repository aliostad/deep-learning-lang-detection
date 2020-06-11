(ns azjure.cipher.streamcipher
  "## Stream Cipher
  Stream cipher multimethod definitions.

  All stream ciphers should define defmethods for these multimethods.

  The currently supported stream cipher type keywords for use in the
  configuration map are:

    :chacha  - ChaCha
    :salsa20 - Salsa20"
  {:author "Jason Ozias"})

(defmulti iv-size-bits
          "### iv-size-bits
  Evaluates to the IV size in bits supported by the stream cipher in
  bits"
          {:added "0.2.0"}
          :type)
(defmulti keystream-size-bytes
          "### keystream-size-bytes
  Evaluates to the keystream size supported by the stream cipher in
  bytes under one key.  This is generally a large value."
          {:added "0.2.0"}
          :type)
(defmulti generate-keystream
          "### generate-keystream
  Generate the stream cipher keystream"
          {:added "0.2.0"}
          :type)