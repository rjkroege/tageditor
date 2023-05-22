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

  func build(startingtag: ID3Tag) -> ID3Tag {
    let tag = self.build()
    tag.frames = tag.frames.merging(startingtag.frames) { (current, _) in current }
    return tag
  }
}

extension ID32v2TagBuilder: LCDTagBuilder {}

extension ID32v3TagBuilder: LCDTagBuilder {}

extension ID32v4TagBuilder: LCDTagBuilder {}
