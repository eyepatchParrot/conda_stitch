#include <gtest/gtest.h>
#include <zlib.h>
#include <string>
#include <vector>
#include <iostream>

// --- Helper functions for zlib compression/decompression ---

// Compresses a string using zlib
// Returns true on success, false on failure.
// Compressed data is stored in 'compressed_data'.
bool compressString(const std::string& input, std::vector<unsigned char>& compressed_data) {
    if (input.empty()) {
        compressed_data.clear();
        return true; // Empty input compresses to empty output (or minimal header)
    }

    // Estimate buffer size: input size + 0.1% + 12 bytes for zlib overhead
    uLongf compressed_buffer_size = compressBound(input.length());
    compressed_data.resize(compressed_buffer_size);

    int result = compress(
        compressed_data.data(),
        &compressed_buffer_size,
        reinterpret_cast<const Bytef*>(input.data()),
        input.length()
    );

    if (result == Z_OK) {
        compressed_data.resize(compressed_buffer_size); // Resize to actual compressed size
        return true;
    } else {
        std::cerr << "zlib compression failed with error: " << result << std::endl;
        compressed_data.clear();
        return false;
    }
}

// Decompresses data using zlib                                                                   
// Returns true on success, false on failure.                                                     
// Decompressed string is stored in 'decompressed_string'.                                        
bool decompressString(const std::vector<unsigned char>& compressed_data, uLongf decompressed_size, std::string& decompressed_string) {
    std::cout << "compressed_size" << compressed_data.size() << " decompressed_size=" << decompressed_size << std::endl;
    if (compressed_data.empty()) {
        decompressed_string.clear();
        return true; // Empty compressed data decompresses to empty string
    }

    // Now allocate a buffer of the exact required size
    std::vector<unsigned char> decompressed_buffer(decompressed_size);

    // Second pass: actual decompression
    int result = uncompress(
        decompressed_buffer.data(),
        &decompressed_size,
        compressed_data.data(),
        compressed_data.size()
    );

    if (result != Z_OK) {
        std::cerr << __FILE__ << ':' << __LINE__ << ": zlib decompression failed with error: " << zError(result) << std::endl;
        return false;
    }

    decompressed_string.assign(reinterpret_cast<char*>(decompressed_buffer.data()), decompressed_size);
    return true;
}

// --- Gtest Test Fixture (Optional but good practice for related tests) ---

class ZlibTest : public ::testing::Test {
protected:
    // You can set up common resources here, e.g., large test data
    void SetUp() override {
        // No specific setup needed for this simple example
    }

    void TearDown() override {
        // Clean up resources if any
    }
};

// --- Gtest Test Cases ---

TEST_F(ZlibTest, CompressesAndDecompressesCorrectly) {
    std::string original_data = "Hello, zlib! This is a test string for compression and decompression.";
    std::vector<unsigned char> compressed;
    std::string decompressed;

    // Test compression
    ASSERT_TRUE(compressString(original_data, compressed)) << "Compression failed!";
    ASSERT_FALSE(compressed.empty()) << "Compressed data should not be empty for non-empty input.";
    std::cout << "compressed_size" << compressed.size() << std::endl;

    // Test decompression
    ASSERT_TRUE(decompressString(compressed, original_data.size(), decompressed)) << "Decompression failed!";
    ASSERT_EQ(original_data, decompressed) << "Decompressed data does not match original!";
}

TEST_F(ZlibTest, HandlesEmptyInput) {
    std::string original_data = "";
    std::vector<unsigned char> compressed;
    std::string decompressed;

    // Test compression of empty string
    ASSERT_TRUE(compressString(original_data, compressed)) << "Compression of empty string failed!";
    // Compressed data for empty string might be very small (just header) or empty depending on zlib version/flags.
    // For simplicity, we'll check if decompression works.
    
    // Test decompression of empty or minimal compressed data
    ASSERT_TRUE(decompressString(compressed, original_data.size(), decompressed)) << "Decompression of empty compressed data failed!";
    ASSERT_EQ(original_data, decompressed) << "Decompressed empty data does not match original empty string!";
}

TEST_F(ZlibTest, HandlesLargeInput) {
    std::string original_data(10000, 'A'); // 10,000 'A' characters
    std::vector<unsigned char> compressed;
    std::string decompressed;

    ASSERT_TRUE(compressString(original_data, compressed)) << "Compression of large string failed!";
    ASSERT_FALSE(compressed.empty()) << "Compressed data should not be empty for large input.";
    std::cout << "compressed_size" << compressed.size() << std::endl;
    // The compressed size should be significantly smaller than original for repetitive data
    ASSERT_LT(compressed.size(), original_data.length()) << "Compressed size not smaller than original for repetitive data!";

    ASSERT_TRUE(decompressString(compressed, original_data.size(), decompressed)) << "Decompression of large string failed!";
    ASSERT_EQ(original_data, decompressed) << "Decompressed large data does not match original!";
}

// Note: Testing for explicit zlib errors (like Z_MEM_ERROR) is harder
// without explicitly simulating memory exhaustion or providing invalid compressed data.
// The current functions return false on any zlib error, which is caught by ASSERT_TRUE.

// --- Main function to run all tests ---

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

