const fs = require('fs');
const shell = require('child_process').spawnSync;

const globalVars=['$rootScope', '$scope', '$q', 'socknet'];
const model=process.argv[2]
const name=process.argv[3]
const destDir="src/"+model+"/"+name
const modelDir="./models/"+model

// fs.writeFile('input.txt', 'Simply Easy Learning!',  function(err) {
//    if (err) {
//       return console.error(err);
//    }
//
//    console.log("Data written successfully!");
//    console.log("Let's read newly written data");
//    fs.readFile('input.txt', function (err, data) {
//       if (err) {
//          return console.error(err);
//       }
//       console.log("Asynchronous read: " + data.toString());
//    });
// });
//

const bufPrint = (buf) => {
  console.log(buf.toString());
};

let i=0;
let args;
globalVars.forEach((name) => {
  console.log('Want you use:', name, '?');
  process.stdin.on('readable', () => {
    var chunk = process.stdin.read();
    if (chunk !== null) {
      process.stdout.write(`data: ${chunk}`);
    }
  });
});


fs.readdir(modelDir, (err, files) => {
  if (err) {
    console.log('cant read', modelDir);
    return console.error(err);
  }
  files.forEach(file => {
    // - argvars
    let sed = shell('sed', ['s/##NAME##/'+name+'/g', modelDir+'/'+file]);
    let sed2 = shell('sed', ['s/##ARGS##/'+args+'/g'], {input: sed.stdout});
    console.log('output:');
    bufPrint(sed2.stdout);
    console.log('> ', destDir+'/'+file);
    console.log('---------');

  });
})


// name=$2
//
// component() {
// 	args=""
//   for i in `find ./models/$model/ -type f`
//   do
//   echo "Need
//   done
//
// }
//
// mkdir -p "src/$model/$name"
// for i in `find ./models/$model/ -type f`
// do
// #	sed -e "s/##NAME##/$name/g" > "./src/$model/$name/`basename $i`"
// 	sed -e "s/##NAME##/$name/g" $i
// 	$name
// done
