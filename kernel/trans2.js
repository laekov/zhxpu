(String(require('fs').readFileSync('kernel.out'))).split('\n').forEach(function(x, i) { 
	console.log('16\'h' + (i + 1).toString(16) + ': suppose <= ' + '16\'h' + x + ';'); 
});
