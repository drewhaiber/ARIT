var fs = require('fs');
var content = JSON.parse(fs.readFileSync('fullData_maps.rit.edu.json', 'utf8'));
var results = [];
for (var i = 0; i < content.length; i++) {
    if (content[i].properties && content[i].properties.tag && content[i].properties.tag.includes('Building')) {
        results.push(content[i]);
    }
}
for (var i = 0; i < results.length; i++) {
    results[i].poly = results[i].geometry.coordinates[0];
    delete results[i].geometry;
}
fs.writeFileSync('partData.json', JSON.stringify(results));
console.log(results[0]);
