# CCLocalLibrary

####SomeCategorys that can be installed as a local static library . (as framework , depends how you manage your pods) .

### What's new ?
---

2017-07-01 19:49:01

 I wrote a new library called `CCChainOperate` .
 Why I wrote it ?
 
 well , after years of writing objective-c , i figured some dis-advantage of it . such as you have to use `[]`  everywhere . i just hate that . 
 
 but , as we all know , on the opposite side , `swift` was much better , easily to use , simple to unsderstand (though its haven't stable yet). 
 
  Someday , i find , that block , can actually can perform a style like swift , therefore `CCChainOperate ` was born (not complete yet , maybe , forever , but i'll try.).
  
  Also , heavily inspired by react-Objc .

### How to use ?
---

For freshmen :

1. Download first or clone the git repo .
2. open `Terminal` , `cd` and make right into where the `Podfile` placed in .
3. `pod install`
4. open `*.xcworkspace`
5. see the content in the `Podfile` .
6. see the conten in the locallib.spec
7. if you can't find the spec file , use `mdfind` command in `Terminal`.	


  `pod 'LocalLib' , :path => '../LocalLib'`
