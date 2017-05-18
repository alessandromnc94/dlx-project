import os

os_walk_val = os.walk('.')

for dirpath, dirnames, filenames in os_walk_val:
    if len(dirnames) + len(filenames) == 0:
        open(os.path.join(dirpath, ".gitkeep"), "w").close()
    elif ".gitkeep" in filenames:
        os.remove(os.path.join(dirpath, ".gitkeep"))