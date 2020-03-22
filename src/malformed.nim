import os, strformat, re

proc test_a_file(path: string): int =
  execShellCmd(fmt"xmllint {path}  2>&1 1>/dev/null")

proc walk_and_check(directory: string): seq[string] =
  for file in walkDirRec directory:
    if file.match re".*\.xml":
      let 
        current_file = test_a_file(file)
      if current_file != 0:
        result.add(file)

proc write_bad_files(bad_files: seq[string]) =
  writeFile("bad_files.txt", $bad_files)

when isMainModule:
  let bad_files = walk_and_check("/home/mark/nim_projects/digital_commons_downloader/xml")
  write_bad_files(bad_files)
  echo fmt"Found {len(bad_files)} bad file(s): {bad_files}"
