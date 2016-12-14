#!/usr/bin/env node

const fs = require("fs");
const moment = require("moment");

const result =
    fs.readFileSync(`${__dirname}/new.csv`, { encoding: 'utf-8' })
        // Split the file into an array by line endings
        .split("\r\n")
        
        // We only care about lines that start with a digit (they are the transactions)
        .filter(line => line.match(/^[0-9].*$/))
        
        // Transform the line into the format that Freeagent wants
        .map(line => {
            const row = line.split(";");
            
            const credit = parseFloat(row[2].replace("'", "")) || 0;
            const debit = parseFloat(row[3].replace("'", "")) || 0;
            const details = `${row[1]}`;
            const date = moment(row[0].replace(/\./g, "/")).format("DD/MM/YYYY");
            
            // Since credit and debit contain the sign (+ or -) we can just add them together as parseInt will already have dealt with it
            return [ date, credit + debit, details ];
        })
        
        // And turn it back into rows
        .map(row => row.join(","))
        
        // And finally a string;
        .join("\n");

fs.writeFileSync(`${__dirname}/new-converted.csv`, result, { encoding: 'utf-8' });