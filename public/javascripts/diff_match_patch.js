function diff_match_patch(){this.Diff_Timeout=1.0;this.Diff_EditCost=4;this.Diff_DualThreshold=32;this.Match_Balance=0.5;this.Match_Threshold=0.5;this.Match_MinLength=100;this.Match_MaxLength=1000;this.Patch_Margin=4;function getMaxBits(){var a=0;var b=1;var c=2;while(b!=c){a++;b=c;c=c<<1}return a}this.Match_MaxBits=getMaxBits()}var DIFF_DELETE=-1;var DIFF_INSERT=1;var DIFF_EQUAL=0;diff_match_patch.prototype.diff_main=function(a,b,c){if(a==b){return[[DIFF_EQUAL,a]]}if(typeof c=='undefined'){c=true}var d=c;var e=this.diff_commonPrefix(a,b);var f=a.substring(0,e);a=a.substring(e);b=b.substring(e);e=this.diff_commonSuffix(a,b);var g=a.substring(a.length-e);a=a.substring(0,a.length-e);b=b.substring(0,b.length-e);var h=this.diff_compute(a,b,d);if(f){h.unshift([DIFF_EQUAL,f])}if(g){h.push([DIFF_EQUAL,g])}this.diff_cleanupMerge(h);return h};diff_match_patch.prototype.diff_compute=function(b,c,d){var e;if(!b){return[[DIFF_INSERT,c]]}if(!c){return[[DIFF_DELETE,b]]}var f=b.length>c.length?b:c;var g=b.length>c.length?c:b;var i=f.indexOf(g);if(i!=-1){e=[[DIFF_INSERT,f.substring(0,i)],[DIFF_EQUAL,g],[DIFF_INSERT,f.substring(i+g.length)]];if(b.length>c.length){e[0][0]=e[2][0]=DIFF_DELETE}return e}f=g=null;var h=this.diff_halfMatch(b,c);if(h){var k=h[0];var l=h[1];var m=h[2];var n=h[3];var o=h[4];var p=this.diff_main(k,m,d);var q=this.diff_main(l,n,d);return p.concat([[DIFF_EQUAL,o]],q)}if(d&&(b.length<100||c.length<100)){d=false}var r;if(d){var a=this.diff_linesToChars(b,c);b=a[0];c=a[1];r=a[2]}e=this.diff_map(b,c);if(!e){e=[[DIFF_DELETE,b],[DIFF_INSERT,c]]}if(d){this.diff_charsToLines(e,r);this.diff_cleanupSemantic(e);e.push([DIFF_EQUAL,'']);var s=0;var t=0;var u=0;var v='';var w='';while(s<e.length){switch(e[s][0]){case DIFF_INSERT:u++;w+=e[s][1];break;case DIFF_DELETE:t++;v+=e[s][1];break;case DIFF_EQUAL:if(t>=1&&u>=1){var a=this.diff_main(v,w,false);e.splice(s-t-u,t+u);s=s-t-u;for(var j=a.length-1;j>=0;j--){e.splice(s,0,a[j])}s=s+a.length}u=0;t=0;v='';w='';break}s++}e.pop()}return e};diff_match_patch.prototype.diff_linesToChars=function(g,h){var i=[];var j={};i[0]='';function diff_linesToCharsMunge(a){var b='';var c=0;var d=-1;var e=i.length;while(d<a.length-1){d=a.indexOf('\n',c);if(d==-1){d=a.length-1}var f=a.substring(c,d+1);c=d+1;if(j.hasOwnProperty?j.hasOwnProperty(f):(j[f]!==undefined)){b+=String.fromCharCode(j[f])}else{b+=String.fromCharCode(e);j[f]=e;i[e++]=f}}return b}var k=diff_linesToCharsMunge(g);var l=diff_linesToCharsMunge(h);return[k,l,i]};diff_match_patch.prototype.diff_charsToLines=function(a,b){for(var x=0;x<a.length;x++){var c=a[x][1];var d=[];for(var y=0;y<c.length;y++){d[y]=b[c.charCodeAt(y)]}a[x][1]=d.join('')}};diff_match_patch.prototype.diff_map=function(b,c){var e=(new Date()).getTime()+this.Diff_Timeout*1000;var f=b.length+c.length-1;var g=this.Diff_DualThreshold*2<f;var h=[];var i=[];var j={};var l={};j[1]=0;l[1]=0;var x,y;var m;var n={};var o=false;var hasOwnProperty=!!(n.hasOwnProperty);var p=(b.length+c.length)%2;for(var d=0;d<f;d++){if(this.Diff_Timeout>0&&(new Date()).getTime()>e){return null}h[d]={};for(var k=-d;k<=d;k+=2){if(k==-d||k!=d&&j[k-1]<j[k+1]){x=j[k+1]}else{x=j[k-1]+1}y=x-k;if(g){m=x+','+y;if(p&&(hasOwnProperty?n.hasOwnProperty(m):(n[m]!==undefined))){o=true}if(!p){n[m]=d}}while(!o&&x<b.length&&y<c.length&&b.charAt(x)==c.charAt(y)){x++;y++;if(g){m=x+','+y;if(p&&(hasOwnProperty?n.hasOwnProperty(m):(n[m]!==undefined))){o=true}if(!p){n[m]=d}}}j[k]=x;h[d][x+','+y]=true;if(x==b.length&&y==c.length){return this.diff_path1(h,b,c)}else if(o){i=i.slice(0,n[m]+1);var a=this.diff_path1(h,b.substring(0,x),c.substring(0,y));return a.concat(this.diff_path2(i,b.substring(x),c.substring(y)))}}if(g){i[d]={};for(var k=-d;k<=d;k+=2){if(k==-d||k!=d&&l[k-1]<l[k+1]){x=l[k+1]}else{x=l[k-1]+1}y=x-k;m=(b.length-x)+','+(c.length-y);if(!p&&(hasOwnProperty?n.hasOwnProperty(m):(n[m]!==undefined))){o=true}if(p){n[m]=d}while(!o&&x<b.length&&y<c.length&&b.charAt(b.length-x-1)==c.charAt(c.length-y-1)){x++;y++;m=(b.length-x)+','+(c.length-y);if(!p&&(hasOwnProperty?n.hasOwnProperty(m):(n[m]!==undefined))){o=true}if(p){n[m]=d}}l[k]=x;i[d][x+','+y]=true;if(o){h=h.slice(0,n[m]+1);var a=this.diff_path1(h,b.substring(0,b.length-x),c.substring(0,c.length-y));return a.concat(this.diff_path2(i,b.substring(b.length-x),c.substring(c.length-y)))}}}}return null};diff_match_patch.prototype.diff_path1=function(a,b,c){var e=[];var x=b.length;var y=c.length;var f=null;for(var d=a.length-2;d>=0;d--){while(1){if(a[d].hasOwnProperty?a[d].hasOwnProperty((x-1)+','+y):(a[d][(x-1)+','+y]!==undefined)){x--;if(f===DIFF_DELETE){e[0][1]=b.charAt(x)+e[0][1]}else{e.unshift([DIFF_DELETE,b.charAt(x)])}f=DIFF_DELETE;break}else if(a[d].hasOwnProperty?a[d].hasOwnProperty(x+','+(y-1)):(a[d][x+','+(y-1)]!==undefined)){y--;if(f===DIFF_INSERT){e[0][1]=c.charAt(y)+e[0][1]}else{e.unshift([DIFF_INSERT,c.charAt(y)])}f=DIFF_INSERT;break}else{x--;y--;if(f===DIFF_EQUAL){e[0][1]=b.charAt(x)+e[0][1]}else{e.unshift([DIFF_EQUAL,b.charAt(x)])}f=DIFF_EQUAL}}}return e};diff_match_patch.prototype.diff_path2=function(a,b,c){var e=[];var f=0;var x=b.length;var y=c.length;var g=null;for(var d=a.length-2;d>=0;d--){while(1){if(a[d].hasOwnProperty?a[d].hasOwnProperty((x-1)+','+y):(a[d][(x-1)+','+y]!==undefined)){x--;if(g===DIFF_DELETE){e[f-1][1]+=b.charAt(b.length-x-1)}else{e[f++]=[DIFF_DELETE,b.charAt(b.length-x-1)]}g=DIFF_DELETE;break}else if(a[d].hasOwnProperty?a[d].hasOwnProperty(x+','+(y-1)):(a[d][x+','+(y-1)]!==undefined)){y--;if(g===DIFF_INSERT){e[f-1][1]+=c.charAt(c.length-y-1)}else{e[f++]=[DIFF_INSERT,c.charAt(c.length-y-1)]}g=DIFF_INSERT;break}else{x--;y--;if(g===DIFF_EQUAL){e[f-1][1]+=b.charAt(b.length-x-1)}else{e[f++]=[DIFF_EQUAL,b.charAt(b.length-x-1)]}g=DIFF_EQUAL}}}return e};diff_match_patch.prototype.diff_commonPrefix=function(a,b){if(!a||!b||a.charCodeAt(0)!==b.charCodeAt(0)){return 0}var c=0;var d=Math.min(a.length,b.length);var e=d;var f=0;while(c<e){if(a.substring(f,e)==b.substring(f,e)){c=e;f=c}else{d=e}e=Math.floor((d-c)/2+c)}return e};diff_match_patch.prototype.diff_commonSuffix=function(a,b){if(!a||!b||a.charCodeAt(a.length-1)!==b.charCodeAt(b.length-1)){return 0}var c=0;var d=Math.min(a.length,b.length);var e=d;var f=0;while(c<e){if(a.substring(a.length-e,a.length-f)==b.substring(b.length-e,b.length-f)){c=e;f=c}else{d=e}e=Math.floor((d-c)/2+c)}return e};diff_match_patch.prototype.diff_halfMatch=function(h,k){var l=h.length>k.length?h:k;var m=h.length>k.length?k:h;if(l.length<10||m.length<1){return null}var n=this;function diff_halfMatchI(a,b,i){var c=a.substring(i,i+Math.floor(a.length/4));var j=-1;var d='';var e,best_longtext_b,best_shorttext_a,best_shorttext_b;while((j=b.indexOf(c,j+1))!=-1){var f=n.diff_commonPrefix(a.substring(i),b.substring(j));var g=n.diff_commonSuffix(a.substring(0,i),b.substring(0,j));if(d.length<g+f){d=b.substring(j-g,j)+b.substring(j,j+f);e=a.substring(0,i-g);best_longtext_b=a.substring(i+f);best_shorttext_a=b.substring(0,j-g);best_shorttext_b=b.substring(j+f)}}if(d.length>=a.length/2){return[e,best_longtext_b,best_shorttext_a,best_shorttext_b,d]}else{return null}}var o=diff_halfMatchI(l,m,Math.ceil(l.length/4));var p=diff_halfMatchI(l,m,Math.ceil(l.length/2));var q;if(!o&&!p){return null}else if(!p){q=o}else if(!o){q=p}else{q=o[4].length>p[4].length?o:p}var r,text1_b,text2_a,text2_b;if(h.length>k.length){r=q[0];text1_b=q[1];text2_a=q[2];text2_b=q[3]}else{text2_a=q[0];text2_b=q[1];r=q[2];text1_b=q[3]}var s=q[4];return[r,text1_b,text2_a,text2_b,s]};diff_match_patch.prototype.diff_cleanupSemantic=function(a){var b=false;var c=[];var d=0;var e=null;var f=0;var g=0;var h=0;while(f<a.length){if(a[f][0]==DIFF_EQUAL){c[d++]=f;g=h;h=0;e=a[f][1]}else{h+=a[f][1].length;if(e!==null&&(e.length<=g)&&(e.length<=h)){a.splice(c[d-1],0,[DIFF_DELETE,e]);a[c[d-1]+1][0]=DIFF_INSERT;d--;d--;f=d>0?c[d-1]:-1;g=0;h=0;e=null;b=true}}f++}if(b){this.diff_cleanupMerge(a)}this.diff_cleanupSemanticLossless(a)};diff_match_patch.prototype.diff_cleanupSemanticLossless=function(d){var e=/[^a-zA-Z0-9]/;var f=/\s/;var g=/[\r\n]/;var h=/\n\r?\n$/;var i=/^\r?\n\r?\n/;function diff_cleanupSemanticScore(a,b){if(!a||!b){return 5}var c=0;if(a.charAt(a.length-1).match(e)||b.charAt(0).match(e)){c++;if(a.charAt(a.length-1).match(f)||b.charAt(0).match(f)){c++;if(a.charAt(a.length-1).match(g)||b.charAt(0).match(g)){c++;if(a.match(h)||b.match(i)){c++}}}}return c}var j=1;while(j<d.length-1){if(d[j-1][0]==DIFF_EQUAL&&d[j+1][0]==DIFF_EQUAL){var k=d[j-1][1];var l=d[j][1];var m=d[j+1][1];var n=this.diff_commonSuffix(k,l);if(n){var o=l.substring(l.length-n);k=k.substring(0,k.length-n);l=o+l.substring(0,l.length-n);m=o+m}var p=k;var q=l;var r=m;var s=diff_cleanupSemanticScore(k,l)+diff_cleanupSemanticScore(l,m);while(l.charAt(0)===m.charAt(0)){k+=l.charAt(0);l=l.substring(1)+m.charAt(0);m=m.substring(1);var t=diff_cleanupSemanticScore(k,l)+diff_cleanupSemanticScore(l,m);if(t>=s){s=t;p=k;q=l;r=m}}if(d[j-1][1]!=p){if(p){d[j-1][1]=p}else{d.splice(j-1,1);j--}d[j][1]=q;if(r){d[j+1][1]=r}else{d.splice(j+1,1);j--}}}j++}};diff_match_patch.prototype.diff_cleanupEfficiency=function(a){var b=false;var c=[];var d=0;var e='';var f=0;var g=false;var h=false;var i=false;var j=false;while(f<a.length){if(a[f][0]==DIFF_EQUAL){if(a[f][1].length<this.Diff_EditCost&&(i||j)){c[d++]=f;g=i;h=j;e=a[f][1]}else{d=0;e=''}i=j=false}else{if(a[f][0]==DIFF_DELETE){j=true}else{i=true}if(e&&((g&&h&&i&&j)||((e.length<this.Diff_EditCost/2)&&(g+h+i+j)==3))){a.splice(c[d-1],0,[DIFF_DELETE,e]);a[c[d-1]+1][0]=DIFF_INSERT;d--;e='';if(g&&h){i=j=true;d=0}else{d--;f=d>0?c[d-1]:-1;i=j=false}b=true}}f++}if(b){this.diff_cleanupMerge(a)}};diff_match_patch.prototype.diff_cleanupMerge=function(a){a.push([DIFF_EQUAL,'']);var b=0;var c=0;var d=0;var e='';var f='';var g;while(b<a.length){switch(a[b][0]){case DIFF_INSERT:d++;f+=a[b][1];b++;break;case DIFF_DELETE:c++;e+=a[b][1];b++;break;case DIFF_EQUAL:if(c!==0||d!==0){if(c!==0&&d!==0){g=this.diff_commonPrefix(f,e);if(g!==0){if((b-c-d)>0&&a[b-c-d-1][0]==DIFF_EQUAL){a[b-c-d-1][1]+=f.substring(0,g)}else{a.splice(0,0,[DIFF_EQUAL,f.substring(0,g)]);b++}f=f.substring(g);e=e.substring(g)}g=this.diff_commonSuffix(f,e);if(g!==0){a[b][1]=f.substring(f.length-g)+a[b][1];f=f.substring(0,f.length-g);e=e.substring(0,e.length-g)}}if(c===0){a.splice(b-c-d,c+d,[DIFF_INSERT,f])}else if(d===0){a.splice(b-c-d,c+d,[DIFF_DELETE,e])}else{a.splice(b-c-d,c+d,[DIFF_DELETE,e],[DIFF_INSERT,f])}b=b-c-d+(c?1:0)+(d?1:0)+1}else if(b!==0&&a[b-1][0]==DIFF_EQUAL){a[b-1][1]+=a[b][1];a.splice(b,1)}else{b++}d=0;c=0;e='';f='';break}}if(a[a.length-1][1]===''){a.pop()}var h=false;b=1;while(b<a.length-1){if(a[b-1][0]==DIFF_EQUAL&&a[b+1][0]==DIFF_EQUAL){if(a[b][1].substring(a[b][1].length-a[b-1][1].length)==a[b-1][1]){a[b][1]=a[b-1][1]+a[b][1].substring(0,a[b][1].length-a[b-1][1].length);a[b+1][1]=a[b-1][1]+a[b+1][1];a.splice(b-1,1);h=true}else if(a[b][1].substring(0,a[b+1][1].length)==a[b+1][1]){a[b-1][1]+=a[b+1][1];a[b][1]=a[b][1].substring(a[b+1][1].length)+a[b+1][1];a.splice(b+1,1);h=true}}b++}if(h){this.diff_cleanupMerge(a)}};diff_match_patch.prototype.diff_xIndex=function(a,b){var c=0;var d=0;var e=0;var f=0;var x;for(x=0;x<a.length;x++){if(a[x][0]!==DIFF_INSERT){c+=a[x][1].length}if(a[x][0]!==DIFF_DELETE){d+=a[x][1].length}if(c>b){break}e=c;f=d}if(a.length!=x&&a[x][0]===DIFF_DELETE){return f}return f+(b-e)};diff_match_patch.prototype.diff_prettyHtml=function(a){var b=[];var i=0;for(var x=0;x<a.length;x++){var c=a[x][0];var d=a[x][1];var e=d.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\n/g,'&para;<BR>');switch(c){case DIFF_INSERT:b[x]='<INS STYLE="background:#E6FFE6;" TITLE="i='+i+'">'+e+'</INS>';break;case DIFF_DELETE:b[x]='<DEL STYLE="background:#FFE6E6;" TITLE="i='+i+'">'+e+'</DEL>';break;case DIFF_EQUAL:b[x]='<SPAN TITLE="i='+i+'">'+e+'</SPAN>';break}if(c!==DIFF_DELETE){i+=d.length}}return b.join('')};diff_match_patch.prototype.diff_text1=function(a){var b=[];for(var x=0;x<a.length;x++){if(a[x][0]!==DIFF_INSERT){b[x]=a[x][1]}}return b.join('')};diff_match_patch.prototype.diff_text2=function(a){var b=[];for(var x=0;x<a.length;x++){if(a[x][0]!==DIFF_DELETE){b[x]=a[x][1]}}return b.join('')};diff_match_patch.prototype.diff_toDelta=function(a){var b=[];for(var x=0;x<a.length;x++){switch(a[x][0]){case DIFF_INSERT:b[x]='+'+encodeURI(a[x][1]);break;case DIFF_DELETE:b[x]='-'+a[x][1].length;break;case DIFF_EQUAL:b[x]='='+a[x][1].length;break}}return b.join('\t').replace(/\x00/g,'%00').replace(/%20/g,' ')};diff_match_patch.prototype.diff_fromDelta=function(a,b){var c=[];var d=0;var e=0;b=b.replace(/%00/g,'\0');var f=b.split(/\t/g);for(var x=0;x<f.length;x++){var g=f[x].substring(1);switch(f[x].charAt(0)){case'+':try{c[d++]=[DIFF_INSERT,decodeURI(g)]}catch(ex){throw new Error('Illegal escape in diff_fromDelta: '+g);}break;case'-':case'=':var n=parseInt(g,10);if(isNaN(n)||n<0){throw new Error('Invalid number in diff_fromDelta: '+g);}var h=a.substring(e,e+=n);if(f[x].charAt(0)=='='){c[d++]=[DIFF_EQUAL,h]}else{c[d++]=[DIFF_DELETE,h]}break;default:if(f[x]){throw new Error('Invalid diff operation in diff_fromDelta: '+f[x]);}}}if(e!=a.length){throw new Error('Delta length ('+e+') does not equal source text length ('+a.length+').');}return c};diff_match_patch.prototype.match_main=function(a,b,c){c=Math.max(0,Math.min(c,a.length-b.length));if(a==b){return 0}else if(a.length===0){return null}else if(a.substring(c,c+b.length)==b){return c}else{return this.match_bitap(a,b,c)}};diff_match_patch.prototype.match_bitap=function(a,b,c){if(b.length>this.Match_MaxBits){throw new Error('Pattern too long for this browser.');}var s=this.match_alphabet(b);var f=a.length;f=Math.max(f,this.Match_MinLength);f=Math.min(f,this.Match_MaxLength);var g=this;function match_bitapScore(e,x){var d=Math.abs(c-x);return(e/b.length/g.Match_Balance)+(d/f/(1.0-g.Match_Balance))}var h=this.Match_Threshold;var i=a.indexOf(b,c);if(i!=-1){h=Math.min(match_bitapScore(0,i),h)}i=a.lastIndexOf(b,c+b.length);if(i!=-1){h=Math.min(match_bitapScore(0,i),h)}var k=1<<(b.length-1);i=null;var l,bin_mid;var m=Math.max(c+c,a.length);var n;for(var d=0;d<b.length;d++){var o=Array(a.length);l=c;bin_mid=m;while(l<bin_mid){if(match_bitapScore(d,bin_mid)<h){l=bin_mid}else{m=bin_mid}bin_mid=Math.floor((m-l)/2+l)}m=bin_mid;var p=Math.max(0,c-(bin_mid-c)-1);var q=Math.min(a.length-1,b.length+bin_mid);if(a.charAt(q)==b.charAt(b.length-1)){o[q]=(1<<(d+1))-1}else{o[q]=(1<<d)-1}for(var j=q-1;j>=p;j--){if(d===0){o[j]=((o[j+1]<<1)|1)&s[a.charAt(j)]}else{o[j]=((o[j+1]<<1)|1)&s[a.charAt(j)]|((n[j+1]<<1)|1)|((n[j]<<1)|1)|n[j+1]}if(o[j]&k){var r=match_bitapScore(d,j);if(r<=h){h=r;i=j;if(j>c){p=Math.max(0,c-(j-c))}else{break}}}}if(match_bitapScore(d+1,c)>h){break}n=o}return i};diff_match_patch.prototype.match_alphabet=function(a){var s={};for(var i=0;i<a.length;i++){s[a.charAt(i)]=0}for(var i=0;i<a.length;i++){s[a.charAt(i)]|=1<<(a.length-i-1)}return s};diff_match_patch.prototype.patch_addContext=function(a,b){var c=b.substring(a.start2,a.start2+a.length1);var d=0;while(b.indexOf(c)!=b.lastIndexOf(c)&&c.length<this.Match_MaxBits-this.Patch_Margin-this.Patch_Margin){d+=this.Patch_Margin;c=b.substring(a.start2-d,a.start2+a.length1+d)}d+=this.Patch_Margin;var e=b.substring(a.start2-d,a.start2);if(e!==''){a.diffs.unshift([DIFF_EQUAL,e])}var f=b.substring(a.start2+a.length1,a.start2+a.length1+d);if(f!==''){a.diffs.push([DIFF_EQUAL,f])}a.start1-=e.length;a.start2-=e.length;a.length1+=e.length+f.length;a.length2+=e.length+f.length};diff_match_patch.prototype.patch_make=function(a,b,c){var d,diffs;if(typeof a=='string'&&typeof b=='string'&&typeof c=='undefined'){d=a;diffs=this.diff_main(d,b,true);if(diffs.length>2){this.diff_cleanupSemantic(diffs);this.diff_cleanupEfficiency(diffs)}}else if(typeof a=='object'&&typeof b=='undefined'&&typeof c=='undefined'){diffs=a;d=this.diff_text1(diffs)}else if(typeof a=='string'&&typeof b=='object'&&typeof c=='undefined'){d=a;diffs=b}else if(typeof a=='string'&&typeof b=='string'&&typeof c=='object'){d=a;diffs=c}else{throw new Error('Unknown call format to patch_make.');}if(diffs.length===0){return[]}var e=[];var f=new patch_obj();var g=0;var h=0;var i=0;var j=d;var k=d;for(var x=0;x<diffs.length;x++){var l=diffs[x][0];var m=diffs[x][1];if(!g&&l!==DIFF_EQUAL){f.start1=h;f.start2=i}switch(l){case DIFF_INSERT:f.diffs[g++]=diffs[x];f.length2+=m.length;k=k.substring(0,i)+m+k.substring(i);break;case DIFF_DELETE:f.length1+=m.length;f.diffs[g++]=diffs[x];k=k.substring(0,i)+k.substring(i+m.length);break;case DIFF_EQUAL:if(m.length<=2*this.Patch_Margin&&g&&diffs.length!=x+1){f.diffs[g++]=diffs[x];f.length1+=m.length;f.length2+=m.length}else if(m.length>=2*this.Patch_Margin){if(g){this.patch_addContext(f,j);e.push(f);f=new patch_obj();g=0;j=k}}break}if(l!==DIFF_INSERT){h+=m.length}if(l!==DIFF_DELETE){i+=m.length}}if(g){this.patch_addContext(f,j);e.push(f)}return e};diff_match_patch.prototype.patch_deepCopy=function(a){var b=[];for(var x=0;x<a.length;x++){var c=a[x];var d=new patch_obj();d.diffs=[];for(var y=0;y<c.diffs.length;y++){d.diffs[y]=c.diffs[y].slice()}d.start1=c.start1;d.start2=c.start2;d.length1=c.length1;d.length2=c.length2;b[x]=d}return b};diff_match_patch.prototype.patch_apply=function(a,b){if(a.length==0){return[b,[]]}a=this.patch_deepCopy(a);var c=this.patch_addPadding(a);b=c+b+c;this.patch_splitMax(a);var d=0;var e=[];for(var x=0;x<a.length;x++){var f=a[x].start2+d;var g=this.diff_text1(a[x].diffs);var h=this.match_main(b,g,f);if(h===null){e[x]=false}else{e[x]=true;d=h-f;var i=b.substring(h,h+g.length);if(g==i){b=b.substring(0,h)+this.diff_text2(a[x].diffs)+b.substring(h+g.length)}else{var j=this.diff_main(g,i,false);this.diff_cleanupSemanticLossless(j);var k=0;var l;for(var y=0;y<a[x].diffs.length;y++){var m=a[x].diffs[y];if(m[0]!==DIFF_EQUAL){l=this.diff_xIndex(j,k)}if(m[0]===DIFF_INSERT){b=b.substring(0,h+l)+m[1]+b.substring(h+l)}else if(m[0]===DIFF_DELETE){b=b.substring(0,h+l)+b.substring(h+this.diff_xIndex(j,k+m[1].length))}if(m[0]!==DIFF_DELETE){k+=m[1].length}}}}}b=b.substring(c.length,b.length-c.length);return[b,e]};diff_match_patch.prototype.patch_addPadding=function(a){var b='';for(var x=0;x<this.Patch_Margin;x++){b+=String.fromCharCode(x)}for(var x=0;x<a.length;x++){a[x].start1+=b.length;a[x].start2+=b.length}var c=a[0];var d=c.diffs;if(d.length==0||d[0][0]!=DIFF_EQUAL){d.unshift([DIFF_EQUAL,b]);c.start1-=b.length;c.start2-=b.length;c.length1+=b.length;c.length2+=b.length}else if(b.length>d[0][1].length){var e=b.length-d[0][1].length;d[0][1]=b.substring(d[0][1].length)+d[0][1];c.start1-=e;c.start2-=e;c.length1+=e;c.length2+=e}c=a[a.length-1];d=c.diffs;if(d.length==0||d[d.length-1][0]!=DIFF_EQUAL){d.push([DIFF_EQUAL,b]);c.length1+=b.length;c.length2+=b.length}else if(b.length>d[d.length-1][1].length){var e=b.length-d[d.length-1][1].length;d[d.length-1][1]+=b.substring(0,e);c.length1+=e;c.length2+=e}return b};diff_match_patch.prototype.patch_splitMax=function(a){for(var x=0;x<a.length;x++){if(a[x].length1>this.Match_MaxBits){var b=a[x];a.splice(x--,1);var c=this.Match_MaxBits;var d=b.start1;var e=b.start2;var f='';while(b.diffs.length!==0){var g=new patch_obj();var h=true;g.start1=d-f.length;g.start2=e-f.length;if(f!==''){g.length1=g.length2=f.length;g.diffs.push([DIFF_EQUAL,f])}while(b.diffs.length!==0&&g.length1<c-this.Patch_Margin){var i=b.diffs[0][0];var j=b.diffs[0][1];if(i===DIFF_INSERT){g.length2+=j.length;e+=j.length;g.diffs.push(b.diffs.shift());h=false}else{j=j.substring(0,c-g.length1-this.Patch_Margin);g.length1+=j.length;d+=j.length;if(i===DIFF_EQUAL){g.length2+=j.length;e+=j.length}else{h=false}g.diffs.push([i,j]);if(j==b.diffs[0][1]){b.diffs.shift()}else{b.diffs[0][1]=b.diffs[0][1].substring(j.length)}}}f=this.diff_text2(g.diffs);f=f.substring(f.length-this.Patch_Margin);var k=this.diff_text1(b.diffs).substring(0,this.Patch_Margin);if(k!==''){g.length1+=k.length;g.length2+=k.length;if(g.diffs.length!==0&&g.diffs[g.diffs.length-1][0]===DIFF_EQUAL){g.diffs[g.diffs.length-1][1]+=k}else{g.diffs.push([DIFF_EQUAL,k])}}if(!h){a.splice(++x,0,g)}}}}};diff_match_patch.prototype.patch_toText=function(a){var b=[];for(var x=0;x<a.length;x++){b[x]=a[x]}return b.join('')};diff_match_patch.prototype.patch_fromText=function(a){var b=[];if(!a){return b}a=a.replace(/%00/g,'\0');var c=a.split('\n');var d=0;while(d<c.length){var m=c[d].match(/^@@ -(\d+),?(\d*) \+(\d+),?(\d*) @@$/);if(!m){throw new Error('Invalid patch string: '+c[d]);}var e=new patch_obj();b.push(e);e.start1=parseInt(m[1],10);if(m[2]===''){e.start1--;e.length1=1}else if(m[2]=='0'){e.length1=0}else{e.start1--;e.length1=parseInt(m[2],10)}e.start2=parseInt(m[3],10);if(m[4]===''){e.start2--;e.length2=1}else if(m[4]=='0'){e.length2=0}else{e.start2--;e.length2=parseInt(m[4],10)}d++;while(d<c.length){var f=c[d].charAt(0);try{var g=decodeURI(c[d].substring(1))}catch(ex){throw new Error('Illegal escape in patch_fromText: '+g);}if(f=='-'){e.diffs.push([DIFF_DELETE,g])}else if(f=='+'){e.diffs.push([DIFF_INSERT,g])}else if(f==' '){e.diffs.push([DIFF_EQUAL,g])}else if(f=='@'){break}else if(f===''){}else{throw new Error('Invalid patch mode "'+f+'" in: '+g);}d++}}return b};function patch_obj(){this.diffs=[];this.start1=null;this.start2=null;this.length1=0;this.length2=0}patch_obj.prototype.toString=function(){var a,coords2;if(this.length1===0){a=this.start1+',0'}else if(this.length1==1){a=this.start1+1}else{a=(this.start1+1)+','+this.length1}if(this.length2===0){coords2=this.start2+',0'}else if(this.length2==1){coords2=this.start2+1}else{coords2=(this.start2+1)+','+this.length2}var b=['@@ -'+a+' +'+coords2+' @@\n'];var c;for(var x=0;x<this.diffs.length;x++){switch(this.diffs[x][0]){case DIFF_INSERT:c='+';break;case DIFF_DELETE:c='-';break;case DIFF_EQUAL:c=' ';break}b[x+1]=c+encodeURI(this.diffs[x][1])+'\n'}return b.join('').replace(/\x00/g,'%00').replace(/%20/g,' ')};