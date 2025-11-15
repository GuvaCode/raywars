set name=%~n1
ffmpeg -i "%name%".mp4  -vf "fps=20,scale=480:-1"   "%name%".gif
