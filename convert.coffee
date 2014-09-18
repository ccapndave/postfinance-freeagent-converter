#!/usr/bin/env coffee

fs = require "fs"
csv = require "csv"

csv()
	.from.options(delimiter: "\t", columns: true)
	.from.stream(fs.createReadStream("#{__dirname}/all", { encoding: 'utf-8' }))
	.to.options(delimiter: ",")
	.to(fs.createWriteStream("#{__dirname}/all-converted.csv", { encoding: 'utf-8' }))
	.transform (row) ->
		credit = parseFloat(row["Credit"]) || 0
		debit = parseFloat(row["Debit"]) || 0
		unformattedDate = row["Date"]
		date = unformattedDate.substr(6, 2) + "/" + unformattedDate.substr(4, 2) + "/" + unformattedDate.substr(0, 4)
		[ date, credit - debit, row["Posting details"].replace(/\n/g, "; ") ]
	.on "record", (row,index) ->
		console.log "##{index} #{JSON.stringify(row)}"
