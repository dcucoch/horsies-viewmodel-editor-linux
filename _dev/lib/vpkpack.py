#!/usr/bin/env python3
# Small VPK writer used when Valve's vpk tool is not available.
import os, sys, struct, zlib, hashlib

def build(root, out):
    entries = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames.sort()
        for fn in sorted(filenames):
            full = os.path.join(dirpath, fn)
            rel = os.path.relpath(full, root).replace(os.sep, '/')
            d, base = os.path.split(rel)
            name, ext = os.path.splitext(base)
            ext = ext[1:] if ext.startswith('.') else ext
            # VPK uses a single space for "no extension" and for the root
            # directory. An empty string is the end-of-tree marker, so it
            # must never be used for a real file.
            if ext == '':
                ext = ' '
            path = d if d else ' '
            entries.append((ext, path, name, full))
    entries.sort(key=lambda e: (e[0], e[1], e[2]))
    tree = bytearray(); data = bytearray()
    cur_ext = cur_path = None
    for ext, path, name, full in entries:
        if ext != cur_ext:
            if cur_ext is not None:
                tree += b'\0\0'
            tree += ext.encode('utf-8') + b'\0'
            cur_ext = ext; cur_path = None
        if path != cur_path:
            if cur_path is not None:
                tree += b'\0'
            tree += path.encode('utf-8') + b'\0'
            cur_path = path
        blob = open(full, 'rb').read()
        off = len(data); data += blob
        tree += name.encode('utf-8') + b'\0'
        tree += struct.pack('<IHHIIH', zlib.crc32(blob) & 0xffffffff, 0, 0x7fff, off, len(blob), 0xffff)
    if cur_ext is not None:
        tree += b'\0\0'
    tree += b'\0'
    header = struct.pack('<7I', 0x55aa1234, 2, len(tree), len(data), 0, 48, 0)
    tree_md5 = hashlib.md5(tree).digest()
    archive_md5 = hashlib.md5(b'').digest()
    body = header + tree + data + tree_md5 + archive_md5
    whole_md5 = hashlib.md5(body).digest()
    with open(out, 'wb') as f:
        f.write(body + whole_md5)

if __name__ == '__main__':
    build(sys.argv[1], sys.argv[2])
