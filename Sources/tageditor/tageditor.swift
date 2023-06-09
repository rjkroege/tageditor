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

  @Option(name: .long, help: "Genre (arbitrary string)")
  var genre: String?

  @Option(name: .long, help: "Artwork for the track")
  var picture: String?

  // They would become mandatory optional if I didn't mark it with a ?
  @Option(name: .shortAndLong, help: "Second name")
  var commandlineflag: String?

  @Argument(help: "Mp3 files to alter")
  var tracksToAlter: [String]

  // I don't mutate this structure. If I assigned to self?
  mutating func run() throws {
    if update {
      let pf = buildPictureFrame(context: self)
      for t in tracksToAlter {
        updateTrackName(context: self, trackname: t, pictureframe: pf)
      }
      return
    }

    for t in tracksToAlter {
      perTrack(trackname: t)
    }
  }
}
