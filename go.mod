module github.com/rjkroege/tageditor

go 1.20

require github.com/frolovo22/tag v0.0.2

replace (
	github.com/frolovo22/tag v0.0.2 => ../_builds/tag
)
