# NFT on Sui

1. First and foremost, make sure that the package is compiling, by running the
following commands:

```sh
sui move build
sui move test
```

2. Then to test on sui devnet, publish the package(requires a sui accouunt and some balance to pay gas):

```sh
sui client publish . --gas-budget 10000 --verify-dependencies
```

Output should be similar to:

```sh
Successfully verified dependencies on-chain against source.
----- Certificate ----
Transaction Hash: LN4OyVfxqL/p0TsaxC9qGaEidXuTFxCwlp8xvsbpIWw=
Transaction Signature: AA==@Pr6f9T86AHpM3udbbCaYupt7I4DRnlXAaI0w1gz6+ndSG/2PzXtHRkl9MgghXbuRN1aQNu87lMAiwdZgsljmCw==@pKhGEfmW/5SBVVM8TugZ0rjQqJrnUCgE5IZnVeigqgg=
Signed Authorities Bitmap: RoaringBitmap<[0, 2, 3]>
Transaction Kind : Publish
----- Transaction Effects ----
Status : Success
Created Objects:
  - ID: 0xb12c700f1a51fcafa2bc61ef0113d48edf18f980 , Owner: Immutable
Mutated Objects:
  - ID: 0x0db8113be0c7cf16c1194dad7792c836d9cee9e4 , Owner: Account Address ( 0xc404301d2c5a9791d25b65f58c1383f765af1011 )
```

3. Let's create a new collection in our new contract

```sh
sui client call --function new_collection --module main --package 0xb12c700f1a51fcafa2bc61ef0113d48edf18f980 --args \"Watches\" 1671193699 \"Me\" 2 --gas-budget 10000
```

Output should be similar to :

```sh
----- Certificate ----
Transaction Hash: FjgGO0+f2ut9ZXwT4MGzQ+CCAJvkpK1Zwdap2/xO++c=
Transaction Signature: AA==@TPnv1xPk//p35PVNIWbsIBSIgxZ4vUZRpcxOY5EnQh/Jz22vA8YDAblXiXU30mollfJVj5Q8lLHckKvmmlkSCA==@pKhGEfmW/5SBVVM8TugZ0rjQqJrnUCgE5IZnVeigqgg=
Signed Authorities Bitmap: RoaringBitmap<[1, 2, 3]>
Transaction Kind : Call
Package ID : 0xb12c700f1a51fcafa2bc61ef0113d48edf18f980
Module : main
Function : new_collection
Arguments : ["Watches", 1671193699, "Me", 2]
Type Arguments : []
----- Transaction Effects ----
Status : Success
Created Objects:
  - ID: 0x564c06d41d599e0e8af0ec88abca83643b8dcea1 , Owner: Account Address ( 0xc404301d2c5a9791d25b65f58c1383f765af1011 )
Mutated Objects:
  - ID: 0x0db8113be0c7cf16c1194dad7792c836d9cee9e4 , Owner: Account Address ( 0xc404301d2c5a9791d25b65f58c1383f765af1011 )
```

4. Now, let's mint a new NFT inside this collection

```sh
sui client call --function new_pigment --module main --package 0xb12c700f1a51fcafa2bc61ef0113d48edf18f980 --args \"CASIO\" \"figment://casio-5208\" \"0x564c06d41d599e0e8af0ec88abca83643b8dcea1\" --gas-budget 10000
```

```sh
----- Certificate ----
Transaction Hash: /67wS9OZMNTLnNhuQCgcacphc2H0n4NKMQQbrZDNqf0=
Transaction Signature: AA==@Yl2QXSm22pUCCtP/N9fVF4lNl9JcpHa6jDmU1g5CcIkbRu1yhGIDOTEP3Y1+AkCdKPHawMB7xTQgwKwvk/0QDQ==@pKhGEfmW/5SBVVM8TugZ0rjQqJrnUCgE5IZnVeigqgg=
Signed Authorities Bitmap: RoaringBitmap<[0, 2, 3]>
Transaction Kind : Call
Package ID : 0xb12c700f1a51fcafa2bc61ef0113d48edf18f980
Module : main
Function : new_pigment
Arguments : ["CASIO", "figment://casio-5208", "0x564c06d41d599e0e8af0ec88abca83643b8dcea1"]
Type Arguments : []
----- Transaction Effects ----
Status : Success
Created Objects:
  - ID: 0xd045ae4a5b2e5b6729de3bf102f1b092cbd80169 , Owner: Account Address ( 0xc404301d2c5a9791d25b65f58c1383f765af1011 )
Mutated Objects:
  - ID: 0x0db8113be0c7cf16c1194dad7792c836d9cee9e4 , Owner: Account Address ( 0xc404301d2c5a9791d25b65f58c1383f765af1011 )
  - ID: 0x564c06d41d599e0e8af0ec88abca83643b8dcea1 , Owner: Account Address ( 0xc404301d2c5a9791d25b65f58c1383f765af1011 )
```

5. Repeat this process two more times and on the second try, it will show an error.

```sh
sui client call --function new_pigment --module main --package 0xb12c700f1a51fcafa2bc61ef0113d48edf18f980 --args \"ROLEX\" \"figment://rolex-34\" \"0x564c06d41d599e0e8af0ec88abca83643b8dcea1\" --gas-budget 10000
```

```sh
----- Certificate ----
Transaction Hash: b74WlhGOjFVQw4gaCfXOwITdJoI+Ak00ainnp2gbgSY=
Transaction Signature: AA==@gyfaANdh0EdmCQyqbyAygN+1/ReDb/ApDTV8vPt9Nzh0j4lJwQ7GPL2S9+lbIryJeC/JO5DyUx4UvOZWQr0oBw==@pKhGEfmW/5SBVVM8TugZ0rjQqJrnUCgE5IZnVeigqgg=
Signed Authorities Bitmap: RoaringBitmap<[1, 2, 3]>
Transaction Kind : Call
Package ID : 0xb12c700f1a51fcafa2bc61ef0113d48edf18f980
Module : main
Function : new_pigment
Arguments : ["ROLEX", "figment://rolex-34", "0x564c06d41d599e0e8af0ec88abca83643b8dcea1"]
Type Arguments : []
----- Transaction Effects ----
Status : Success
Created Objects:
  - ID: 0x639fdfd5d2f07e01aa0d335330e7e7d7bdc1b3bd , Owner: Account Address ( 0xc404301d2c5a9791d25b65f58c1383f765af1011 )
Mutated Objects:
  - ID: 0x0db8113be0c7cf16c1194dad7792c836d9cee9e4 , Owner: Account Address ( 0xc404301d2c5a9791d25b65f58c1383f765af1011 )
  - ID: 0x564c06d41d599e0e8af0ec88abca83643b8dcea1 , Owner: Account Address ( 0xc404301d2c5a9791d25b65f58c1383f765af1011 )
```

```sh
sui client call --function new_pigment --module main --package 0xb12c700f1a51fcafa2bc61ef0113d48edf18f980 --args \"ROLEX\" \"figment://rolex-34\" \"0x564c06d41d599e0e8af0ec88abca83643b8dcea1\" --gas-budget 10000
```

```sh
Error calling module: Failure {
    error: "MoveAbort(MoveLocation { module: ModuleId { address: b12c700f1a51fcafa2bc61ef0113d48edf18f980, name: Identifier(\"main\") }, function: 2, instruction: 16 }, 1)",
}
```
