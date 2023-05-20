// The Swift Programming Language
// https://docs.swift.org/swift-book

// [apple/swift-argument-parser: Straightforward, type-safe argument parsing for Swift](https://github.com/apple/swift-argument-parser)
import ArgumentParser
// [ID3TagEditor – Swift Package Index](https://swiftpackageindex.com/chicio/ID3TagEditor)
import ID3TagEditor

// Swift has a bunch of macros called a *property wrapper*. `@main` is one
// such wrapper. It makes the `run` method in the wrapped struct (class?) into
// the global entry point.
@main
struct TagEditor: ParsableCommand {
  @Flag(name: .shortAndLong, help: "update the mp3 tag with the specified values")
  var update = false

  @Option(name: .long, help: "Artist")
  var artist: String?

  @Option(name: .long, help: "Track name aka title")
  var title: String?

  @Option(name: .long, help: "Album name")
  var album: String?

  @Option(name: .long, help: "Track")
  var track: Int?

  @Option(name: .long, help: "Total Tracks")
  var numtracks: Int?

	// TODO(rjk): Handle pictures.


  // They would become mandatory optional if I didn't mark it with a ?
  @Option(name: .shortAndLong, help: "Second name")
  var commandlineflag: String?

  @Argument(help: "Mp3 files to alter")
  var tracksToAlter: [String]

  // I don't mutate this structure. If I assigned to self?
  mutating func run() throws {
    if update {
      for t in tracksToAlter {
        updateTrackName(context: self, trackname: t)
      }
      return
    }

    for t in tracksToAlter {
      perTrack(trackname: t)
    }
  }
}

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

// Write tracks. What do I want to update
// track of total
// album
// title
// artist
// can I pass the TagEditor into this? And it can build?
func updateTrackName(context: TagEditor, trackname: String) {
  // Need to make a builder of the right type. This will require me to
  // learn something new. I want to make a thing
  var maybebuilder: LCDTagBuilder?

  // This API requires me to make an ID3TagEditor first.
  let id3TagEditor = ID3TagEditor()

  do {
    if let id3Tag = try id3TagEditor.read(from: trackname) {
      // build the right kind of builder.
      switch id3Tag.properties.version {
      case .version2:
        maybebuilder = ID32v2TagBuilder()
      case .version3:
        maybebuilder = ID32v3TagBuilder()
      case .version4:
        maybebuilder = ID32v4TagBuilder()
      }
      // TODO(rjk): Do I need an error here? I claim that this shouldn't compile if I've not covered the cases in the enum?
    }
  } catch {
    // TODO(rjk): skip the !mp3 files? (Should do this up above?)
    // Can write a better diag here
    // Might consider skipping.
    print(error)
    return
  }

  // I need this to be var because I mutate it right?
  // Strictly speaking... I could make this not be mutable? Is there a nicer way?
  // Sure? A function? Returns
  let id3Tag = maybebuilder!
    .title(ctx: context)
    .build()

  do {
    // NB: the file has to already exist.
    try id3TagEditor.write(tag: id3Tag, to: trackname)
  } catch {
    print("there was an error! \(error)")
  }

}
