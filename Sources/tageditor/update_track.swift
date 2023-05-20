// [ID3TagEditor – Swift Package Index](https://swiftpackageindex.com/chicio/ID3TagEditor)
import ID3TagEditor

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
    .album(ctx: context)
    .title(ctx: context)
    .build()

  do {
    // NB: the file has to already exist.
    try id3TagEditor.write(tag: id3Tag, to: trackname)
  } catch {
    print("there was an error! \(error)")
  }

}
