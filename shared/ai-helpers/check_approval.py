#!/usr/bin/env python3
"""Check if a command matches approved patterns."""

import json
import sys
import fnmatch
import re
from pathlib import Path

def parse_command_parts(command):
    """Parse command into individual parts separated by pipes, &&, ||, ;"""
    # Split by pipe, &&, ||, and ; operators
    parts = re.split(r'\s*[|&;]+\s*', command.strip())
    # Clean up each part and extract the base command
    cleaned_parts = []
    for part in parts:
        part = part.strip()
        if part:
            # Extract just the command name (first word) for basic commands
            cmd_name = part.split()[0]
            cleaned_parts.append((cmd_name, part))
    return cleaned_parts

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
        
        patterns = data.get('patterns', [])
        
        # Check each part of piped/chained commands
        # Note: We don't check the entire command first because patterns like "find *" 
        # would match dangerous commands like "find . | rm -rf"
        command_parts = parse_command_parts(command)
        
        for cmd_name, full_part in command_parts:
            part_approved = False
            
            # Check if this part matches any pattern
            for pattern in patterns:
                if fnmatch.fnmatch(full_part, pattern) or fnmatch.fnmatch(cmd_name, pattern):
                    part_approved = True
                    break
            
            # If any part is not approved, reject the entire command
            if not part_approved:
                sys.exit(1)
        
        # All parts are approved
        sys.exit(0)
        
    except Exception:
        sys.exit(1)

if __name__ == '__main__':
    main()