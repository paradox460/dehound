task build, "Builds dehound":
  let args = "c -d:release -d:ssl --opt:size dehound.nim"
  selfExec args

  if findExe("upx") != "":
    echo "Running `upx --best`"
    exec "upx --best dehound"
