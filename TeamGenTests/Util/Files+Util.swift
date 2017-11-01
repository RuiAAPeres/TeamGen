import Foundation

func removeFile(atPath path: String) {
    try? FileManager.default.removeItem(atPath: path)
}
