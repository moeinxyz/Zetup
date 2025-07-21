#!/usr/bin/env python3
"""Debug approval checking."""

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
    approved_file = sys.argv[1]
    command = sys.argv[2]
    
    print(f"Checking command: {command}")
    
    with open(approved_file, 'r') as f:
        data = json.load(f)
    
    patterns = data.get('patterns', [])
    print(f"Available patterns: {patterns}")
    
    # Check each part of piped/chained commands
    # Note: We don't check the entire command first because patterns like "find *" 
    # would match dangerous commands like "find . | rm -rf"
    command_parts = parse_command_parts(command)
    print(f"Command parts: {command_parts}")
    
    all_approved = True
    for cmd_name, full_part in command_parts:
        part_approved = False
        print(f"\nChecking part: '{full_part}' (command: '{cmd_name}')")
        
        # Check if this part matches any pattern
        for pattern in patterns:
            if fnmatch.fnmatch(full_part, pattern):
                print(f"  ✅ Full part matches pattern: {pattern}")
                part_approved = True
                break
            elif fnmatch.fnmatch(cmd_name, pattern):
                print(f"  ✅ Command name matches pattern: {pattern}")
                part_approved = True
                break
        
        if not part_approved:
            print(f"  ❌ Part '{full_part}' not approved")
            all_approved = False
        else:
            print(f"  ✅ Part '{full_part}' approved")
    
    if all_approved:
        print("\n✅ All parts approved - ALLOWING command")
        return 0
    else:
        print("\n❌ Some parts not approved - REJECTING command")
        return 1

if __name__ == '__main__':
    sys.exit(main())