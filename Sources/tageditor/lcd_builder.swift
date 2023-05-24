// [ID3TagEditor – Swift Package Index](https://swiftpackageindex.com/chicio/ID3TagEditor)
import ID3TagEditor

// Stuffs to make it possible to
// What is the Self?
// A protocol is an
protocol LCDTagBuilder {
  func build(startingtag: ID3Tag) -> ID3Tag
  func build() -> ID3Tag

  func title(ctx: TagEditor) -> Self
  func title(frame: ID3FrameWithStringContent) -> Self

  func album(ctx: TagEditor) -> Self
  func album(frame: ID3FrameWithStringContent) -> Self

  func artist(ctx: TagEditor) -> Self
  func artist(frame: ID3FrameWithStringContent) -> Self

  func trackPosition(ctx: TagEditor) -> Self
  func trackPosition(frame: ID3FramePartOfTotal) -> Self

  func genre(ctx: TagEditor) -> Self
  func genre(frame: ID3FrameGenre) -> Self

  func attachedPicture(pictureframe: ID3FrameAttachedPicture?) -> Self
  func attachedPicture(pictureType: ID3PictureType, frame: ID3FrameAttachedPicture) -> Self
}

extension LCDTagBuilder {
  func album(ctx: TagEditor) -> Self {
    if let t = ctx.album {
      return self.album(frame: ID3FrameWithStringContent(content: t))
    }
    return self
  }

  func title(ctx: TagEditor) -> Self {
    if let t = ctx.title {
      return self.title(frame: ID3FrameWithStringContent(content: t))
    }
    return self
  }

  func artist(ctx: TagEditor) -> Self {
    if let t = ctx.artist {
      return self.artist(frame: ID3FrameWithStringContent(content: t))
    }
    return self
  }

  func trackPosition(ctx: TagEditor) -> Self {
    if let i = ctx.track, let n = ctx.numtracks {
      return self.trackPosition(frame: ID3FramePartOfTotal(part: i, total: n))
    }
    return self
  }

  func genre(ctx: TagEditor) -> Self {
    if let t = ctx.genre {
      // I am supporting only the custom genres.
      return self.genre(frame: ID3FrameGenre(genre: nil, description: t))
    }
    return self
  }

  func attachedPicture(pictureframe: ID3FrameAttachedPicture?) -> Self {
    if let t = pictureframe {
      // Only the front cover.
      return self.attachedPicture(pictureType: .frontCover, frame: t)
    }
    return self
  }

  func build(startingtag: ID3Tag) -> ID3Tag {
    let tag = self.build()
    tag.frames = tag.frames.merging(startingtag.frames) { (current, _) in current }
    return tag
  }
}

extension ID32v2TagBuilder: LCDTagBuilder {}

extension ID32v3TagBuilder: LCDTagBuilder {}

extension ID32v4TagBuilder: LCDTagBuilder {}
