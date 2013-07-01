fs = require "fs"
csv = require "csv"

# TODO: before running this I need to manually convert it from ansi to utf-8
# TODO: integrate into the browser

csv()
    .from.options(delimiter: ";", columns: true)
    .from.stream(fs.createReadStream("#{__dirname}/all.csv", { encoding: 'utf-8' }))
    .to.options(delimiter: ",")
    .to(fs.createWriteStream("#{__dirname}/all-converted.csv", { encoding: 'utf-8' }))
    .transform (row) ->
        credit = parseFloat(row["Credit"]) || 0
        debit = parseFloat(row["Debit"]) || 0
        [ row["Booking"], credit + debit, row["Booking text"].replace(/\n/g, "; ") ]
    .on "record", (row,index) ->
        console.log "##{index} #{JSON.stringify(row)}"
