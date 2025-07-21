#!/usr/bin/env python3
"""Check if a command matches approved patterns."""

import json
import sys
import fnmatch
from pathlib import Path

def main():
    if len(sys.argv) < 3:
        sys.exit(1)
    
    approved_file = sys.argv[1]
    command = sys.argv[2]
    
    try:
        if not Path(approved_file).exists():
            sys.exit(1)
            
        with open(approved_file, 'r') as f:
            data = json.load(f)
        
        for pattern in data.get('patterns', []):
            if fnmatch.fnmatch(command, pattern):
                sys.exit(0)
        
        sys.exit(1)
    except Exception:
        sys.exit(1)

if __name__ == '__main__':
    main()