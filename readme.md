# Re-typesetting experiment #1

I've scanned pages of the September 1857 issue of _The College Journal of Medical Science_, OCRed these to html (to preserve some formatting) with ABBYY FineReader 9, and am converting those html files into LaTeX files.

A collection of scripts and checklists is coming out of this: scripts to do the heavy lifting translating self-contained HTML to TeX intended to be strung together into a single work, and checklists of small proofreading and hand-formatting tasks that need to be completed on each page.

The individual page TeX files are stitched together and typeset in `./work.tex`, using XeLaTeX. Be sure to check the font assignments; I'm using purchased postscript fonts I own.

## Scripts

* `scripts/html2tex.rb` assumes a lot, and is ripe for refactoring. It runs through all the files in the `html` directory, and "translates" them into identically-named `.tex` files by running through an ad hoc series of regular expression substitutions.
* `scripts/straightener.rb` works through the folder of original page scans (not part of the repository; email me for a 12 Gb copy), and uses ImageMagick to straighten, clean up, and shrink them into something that's more useful for proofreading the text, and might even be small enough to serve in an (eventual) proofreading interface.

## Task list for cleaning up the automatically-generated `.tex` files

In no particular order:

* **add the page file**: edit `work.tex` to append an `\input{}` macro to load the next page file (from `pages/edited/00XY.tex`) into the document's backbone
* **remove html chaff that's still present**: ABBYY saves a lot of extra junk, and the scripts I've written don't remove it all (yet); best to search for `<` throughout and act accordingly where it's found
* **check all hyphens**: hand-remove end-of-line hyphens that need to be cleaned up (for some reason, ABBYY doesn't want to write the "optional hyphen" character, even though it uses it internally). Set en- and em-dashes as normal in LaTeX: en-dashes as `--` and em-dashes as `---`
* **wrap page number in markup**: I've written a simple macro `\oldpage{}` that sets the original scan's page number in the margin of the rendered TeX file
* **look for entities**: quotation marks, especially, and also some ampersands seem to crop up; best to search for the `&` character and address each one
* **fix quotes**: typically ABBYY has recognized and rendered some quotes as `&quot;`, some as `"`, and some as superscript "U"
* **fix inline markup**: ABBYY has some stupidity when it comes to dealing with font faces in the original document. Convert items marked with `<i></i>` markup to TeX's `\emph{}` if they're actually intended for emphasis, or use `\booktitle` for *italicized* titles of magazines and books (note that some are in small caps), and `\foreign` for foreign terms inline (where italicized in the original), and `\latinate` for genus and species names. There probably isn't any real boldface text here, to speak of, but ABBYY has recognized small caps as bold in some cases. Small caps are used in some contexts for proper names, and in others as ad hoc subtitles; just set them all as they look.
* **check first and last lines**: Because the files are stitched together, remove space as appropriate so that at least one blank line appears between two paragraphs, and no blank lines occur between run-on passages where the page breaks within a paragraph. At the end of the page you'll see `\endinput` markup, which tells LaTeX to snip off all remaining contents of that file when inserting.
* **unicode repair**: Em-dashes aren't being created correctly (probably an encoding issue in the current workflow). Best to eyeball the original page scan and look for them. *But* since we're using XeLaTeX, you could also leave the em-dashes as —. One thing I don't want, though, is explicitly typographic (curled) quotes: remove `“”` and `‘’` characters, and replace with LaTeX backticks and apostrophes.
* **spacing after initials and abbreviations**: Check the periods throughout: end-of-sentence periods should remain as normal, but there are many abbreviations and initials, which should be set with non-breaking or non-expandning spaces, like this: `Dr.\ G.~W.\ Carver`, or `Tinct.\ Ammon.\ ...`: in other words, make sure the spaces are *explicit*, and do not allow breaks between initials (there's some variation here).
* **fix punctuation spacing**: The oldstyle rules in the original publication include spaces before semicolons, colons, and some other marks. Check and remove these (they can be re-introduced more easily programmatically, if you're a stickler). Best approach: examine every character that matches the regexp `/\s.\s/`
* **prescriptions**: Some special typographic characters, like "recipe" (℞) and "ounce" (℥), are only present in a few unicode fonts. I've used the sans-serif font to encode these where they appear, and used macros to give access as needed.
* **document structure**: It's up in the air who's a section, who's a chapter, who's a subsection, what to call reviews... blah blah
