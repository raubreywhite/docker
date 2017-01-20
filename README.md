# docker
dockerfiles

# dpython

Kaggle Python + vim-slime = REPL/RStudio knock-off for python

![alt tag](https://raw.githubusercontent.com/raubreywhite/docker/master/screenshots/dpython.png)

To start up the docker container
```
docker pull raw996/dpython
docker run -ti --rm raw996/dpython
```

To open the split screen:
```
screen -S s1
```

To change the focus to the left panel:
```
<ctrl-a>
<tab>
```

To start python in the left panel:
```
python
```

To change the focus back to the right panel:
```
<ctrl-a>
<tab>
```

To start writing a python script in the right panel:
```
vim script.py
```

To send a paragraph to the left screen:
```
Hold down <ctrl> and press c twice
```

The first time, you will be prompted with `screen session name` (answer: `s1`) and `screen window name` (answer: `0`).

