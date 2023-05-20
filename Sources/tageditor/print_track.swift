// [ID3TagEditor – Swift Package Index](https://swiftpackageindex.com/chicio/ID3TagEditor)
import ID3TagEditor

// Prints some tags from a single MP3 file.
func perTrack(trackname: String) {
  print("the track \(trackname)!")

  // This API requires me to make one first.
  let id3TagEditor = ID3TagEditor()

  do {
    if let id3Tag = try id3TagEditor.read(from: trackname) {
      // Get the version
      print("version \(id3Tag.properties.version)")
      if id3Tag.properties.version == ID3Version.version2 {
        print("VERSION 2!!!")
      }

      let tagContentReader = ID3TagContentReader(id3Tag: id3Tag)
      print(tagContentReader.title() ?? "")
      print(tagContentReader.artist() ?? "")
      // ...read other stuff...
    }
  } catch {
    // There's no need to bother with this if the the file isn't an mp3?
    print(error)
  }

}

