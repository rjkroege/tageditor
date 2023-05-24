import Foundation
// [ID3TagEditor – Swift Package Index](https://swiftpackageindex.com/chicio/ID3TagEditor)
import ID3TagEditor

// Observation: it *replaces* all of the tags. All of them. But I don't want this.
// updateTrackName
func updateTrackName(context: TagEditor, trackname: String, pictureframe: ID3FrameAttachedPicture?)
{
  // This is a protocol. We make a different kind based on the tag version.
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
      // TODO(rjk): Do I need an error here? I claim that this shouldn't
      // compile if I've not covered the cases in the enum?

      // I need to stuffs the builder here?

      // I need to update
      let nid3Tag = maybebuilder!
        .album(ctx: context)
        .title(ctx: context)
        .artist(ctx: context)
        .trackPosition(ctx: context)
        .genre(ctx: context)
        .attachedPicture(pictureframe: pictureframe)
        .build(startingtag: id3Tag)

      // NB: the file has to already exist.
      try id3TagEditor.write(tag: nid3Tag, to: trackname)

    }
  } catch {
    // TODO(rjk): skip the !mp3 files? (Should do this up above?)
    // Perhaps we could have better diagnostics here?
    // TODO(rjk): I should (carefully) match the errors with pattern matching.
    print(error)
  }
}

// builds an ID3FrameAttachedPicture from state in context. Returns it
// because context would be immutable in this context. (Passed by "value").
func buildPictureFrame(context: TagEditor) -> ID3FrameAttachedPicture? {
  guard let pf = context.picture else {
    return nil
  }

  // This changes in 13.3+
  let url = URL(fileURLWithPath: pf)
  print("url \(url)")

  guard let ptype = getPtype(ext: url.pathExtension) else {
    return nil
  }

  guard let data = try? Data(contentsOf: url) else {
    return nil
  }

  return ID3FrameAttachedPicture(picture: data, type: ID3PictureType.frontCover, format: ptype)
}

func getPtype(ext: String) -> ID3PictureFormat? {
  print("the extension: \(ext)")
  switch ext {
  case "png":
    return ID3PictureFormat.png
  case "jpeg", "jpg":
    return ID3PictureFormat.jpeg
  default:
    return nil
  }
}
