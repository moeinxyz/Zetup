#!/usr/bin/env python3
"""Add a command to the approved list."""

import json
import sys
from pathlib import Path

def main():
    if len(sys.argv) < 3:
        print("Error: Missing arguments", file=sys.stderr)
        sys.exit(1)
    
    approved_file = sys.argv[1]
    command = sys.argv[2]
    
    try:
        # Read existing data or create new structure
        if Path(approved_file).exists():
            with open(approved_file, 'r') as f:
                data = json.load(f)
        else:
            data = {'patterns': []}
        
        if 'patterns' not in data:
            data['patterns'] = []
        
        # Add command if not already present
        if command not in data['patterns']:
            data['patterns'].append(command)
            data['patterns'].sort()
            
            # Write back to file
            with open(approved_file, 'w') as f:
                json.dump(data, f, indent=2)
            
            print(f'Added "{command}" to approved commands')
        else:
            print(f'"{command}" is already in approved commands')
            
    except Exception as e:
        print(f'Error updating approved commands: {e}', file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()