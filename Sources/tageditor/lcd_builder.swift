// [ID3TagEditor – Swift Package Index](https://swiftpackageindex.com/chicio/ID3TagEditor)
import ID3TagEditor

// Stuffs to make it possible to
// What is the Self?
// A protocol is an
protocol LCDTagBuilder {
  func title(ctx: TagEditor) -> Self
	func title(frame: ID3FrameWithStringContent) -> Self
  func build() -> ID3Tag
}

extension LCDTagBuilder {
  func title(ctx: TagEditor) -> Self {
    if let t = ctx.title {
      return self.title(frame: ID3FrameWithStringContent(content: t))
    }
    return self
  }
}


extension ID32v2TagBuilder: LCDTagBuilder {}
extension ID32v3TagBuilder: LCDTagBuilder {}
extension ID32v4TagBuilder: LCDTagBuilder {}
