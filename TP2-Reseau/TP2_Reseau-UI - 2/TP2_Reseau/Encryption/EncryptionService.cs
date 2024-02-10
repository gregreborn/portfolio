using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace TP2_Reseau.Encryption
{
    public class EncryptionService
    {
        // Encrypts a string using AES encryption with a given key
        public string Encrypt(string plainText, string key)
        {
            if (string.IsNullOrEmpty(plainText) || string.IsNullOrEmpty(key))
            {
                throw new ArgumentException("PlainText or Key cannot be null or empty.");
            }
            byte[] iv = new byte[16];
            byte[] array;

            using (Aes aes = Aes.Create())
            {
                aes.Key = Convert.FromBase64String(key); // Assume key is in Base64 format
                aes.IV = iv;

                ICryptoTransform encryptor = aes.CreateEncryptor(aes.Key, aes.IV);

                using (MemoryStream memoryStream = new MemoryStream())
                {
                    using (CryptoStream cryptoStream = new CryptoStream(memoryStream, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter streamWriter = new StreamWriter(cryptoStream))
                        {
                            streamWriter.Write(plainText);
                        }
                        array = memoryStream.ToArray();
                    }
                }
            }
            return Convert.ToBase64String(array);
        }


        // Decrypts a string using AES encryption with a given key
        public string Decrypt(string cipherText, string key)
        {
            if (string.IsNullOrEmpty(cipherText) || string.IsNullOrEmpty(key))
            {
                throw new ArgumentException("CipherText or Key cannot be null or empty.");
            }

            byte[] iv = new byte[16]; // Initialize to zeros
            byte[] buffer = Convert.FromBase64String(cipherText);

            using (Aes aes = Aes.Create())
            {
                aes.Key = Convert.FromBase64String(key); // Use Base64 format for the key, matching Encrypt method
                aes.IV = iv;

                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);

                using (MemoryStream memoryStream = new MemoryStream(buffer))
                {
                    using (CryptoStream cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader streamReader = new StreamReader(cryptoStream))
                        {
                            return streamReader.ReadToEnd();
                        }
                    }
                }
            }
        }

    }
}
