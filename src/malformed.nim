import os, strformat, re, argparse

proc test_a_file(path: string): int =
  execShellCmd(fmt"xmllint {path}  2>&1 1>/dev/null")

proc walk_and_check(directory: string): seq[string] =
  for file in walkDirRec directory:
    if file.match re".*\.xml":
      let 
        current_file = test_a_file(file)
      if current_file != 0:
        result.add(file)

proc write_bad_files(bad_files: seq[string], output_file: string) =
  writeFile(output_file, $bad_files)

when isMainModule:
  var
    p = newParser("Check XML for well-formedness."):
      option("-p", "--path", help="Specify path to XML.")
      option("-f", "--file", default="bad_files.txt")
    argv = commandLineParams()
    opts = p.parse(argv)
  if opts.path != "":
    let bad_files = walk_and_check(opts.path)
    write_bad_files(bad_files, opts.file)
    echo fmt"Found {len(bad_files)} bad file(s): {bad_files}"
