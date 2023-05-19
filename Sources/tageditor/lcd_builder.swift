// [ID3TagEditor – Swift Package Index](https://swiftpackageindex.com/chicio/ID3TagEditor)
import ID3TagEditor

// Stuffs to make it possible to
// What is the Self?
// A protocol is an
protocol LCDTagBuilder {
  func title(ctx: TagEditor) -> Self
  func build() -> ID3Tag
}

// TODO(rjk): why do I needz to write identical code 3x?
// I need to use an extension to say that the package's TabBuilder implementations satisfy my LCD protocol.
extension ID32v2TagBuilder: LCDTagBuilder {
  func title(ctx: TagEditor) -> Self {
    if let t = ctx.title {
      return self.title(frame: ID3FrameWithStringContent(content: t))
    }
    return self
  }
}

extension ID32v3TagBuilder: LCDTagBuilder {
  func title(ctx: TagEditor) -> Self {
    if let t = ctx.title {
      return self.title(frame: ID3FrameWithStringContent(content: t))
    }
    return self
  }
}

extension ID32v4TagBuilder: LCDTagBuilder {
  func title(ctx: TagEditor) -> Self {
    if let t = ctx.title {
      return self.title(frame: ID3FrameWithStringContent(content: t))
    }
    return self
  }
}
