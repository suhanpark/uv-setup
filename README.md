# uv-setup

This project is for making a simple command to start a project with [uv](https://docs.astral.sh/uv/)

To use, clone this repo to your desired directory.
You can use the shell file as is in your development environment/directory.

If you want to make it into a global executable command,

1. Rename to match command convention
```
cd uv-setup
mv uv-setup.sh uv-setup
```

2. Make it executable
```
chmode +x uv-setup
```

3. Make it system-wide
```
sudo mv uv-setup /usr/local/bin/
```

Now you can go to your project directory that you're starting (e.g., `this/that/here`) and run `uv-setup`.
`here` is where your `main.py` will be.
