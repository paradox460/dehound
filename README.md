Deletes hound comments off PRs. Mac OS only, for now

# Usage
```
dehound <pull-request-url>...
```

Multiple pull requests are supported. Separate with a space. You _may_ want to surround your URLs with `""`

## Authentication
Uses keychain to store access credentials for github. On first run, it should prompt you for an application-specific key.

# Compiling

```
nim build
```

If you have [upx](https://upx.github.io/) installed and available in your PATH, the build script will find and use it to minify the executable.

# FAQs

+ **Can I restore a deleted comment?** Nope, you cannot. Blame github, not me
+ **Why?** Because nothing is better than 50 comments for _every_ push telling you the same thing you already don't care about
+ **Shouldn't you fix your hound first** What makes you think its my hound?

# License
Copyright ©2021 Jeff Sandberg

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
