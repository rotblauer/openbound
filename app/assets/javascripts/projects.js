// /*====================================
// =            diff colorer            =
// ====================================*/

// /*----------  regexes for added content  ----------*/
// // var added = /(\{\+)(.*?)(\+\})/gi;
// // var removed = /(\[\-)(.*?)(\-\])/gi;
// var added = /(\{\+)([\s\S]*?)(\+\})/gim; // regex over multiple lines (whitespace agnostic)
// var removed = /(\[\-)([\s\S]*?)(\-\])/gim;



// /*----------  highlight (change background color) all instances in all text matching the regex  ----------*/
//     // http://stackoverflow.com/questions/1444409/in-javascript-how-can-i-replace-text-in-an-html-page-without-affecting-the-tags

// function replaceInElement(element, find, replace) {
//     // iterate over child nodes in reverse, as replacement may increase
//     // length of child node list.
//     for (var i= element.childNodes.length; i-->0;) {
//         var child= element.childNodes[i];
//         if (child.nodeType==1) { // ELEMENT_NODE
//             var tag= child.nodeName.toLowerCase();
//             if (tag!='style' && tag!='script') // special case, don't touch CDATA elements
//                 replaceInElement(child, find, replace);
//         } else if (child.nodeType==3) { // TEXT_NODE
//             replaceInText(child, find, replace);
//         }
//     }
// }

// function replaceInText(text, find, replace) {
//     var match;
//     var matches= [];
//     while (match= find.exec(text.data))
//         matches.push(match);
//     for (var i= matches.length; i-->0;) {
//         match= matches[i];
//         text.splitText(match.index);
//         text.nextSibling.splitText(match[0].length);
//         text.parentNode.replaceChild(replace(match), text.nextSibling);
//     }
// }

// /*----------  highlight strings changed  ----------*/

// // var replaceIn = document.getElementById('color-me');
// var replaceIn = document.body;

// // added
// replaceInElement(replaceIn, added, function(match) {
//     var matchedString = match[0];
//     var span = document.createElement('span');
//     var trimmed = matchedString.replace(added, "$2"); // replace match with second capture group
//     span.style.backgroundColor = "lightgreen";
//     span.appendChild(document.createTextNode(trimmed));
//  return span;
// });

// // removed
// replaceInElement(replaceIn, removed, function(match) {
//     var matchedString = match[0];
//     var span = document.createElement('span');
//     var trimmed = matchedString.replace(removed, "$2"); 
//     span.style.backgroundColor = "pink";
//     span.appendChild(document.createTextNode(trimmed));
//  return span;
// });

// /*=====  End of diff colorer  ======*/

// /*----------  use html tags  ----------*/

// // var inserted = document.getElementsByClassName('diffins');
// // var deleted = document.getElementsByClassName('diffout');

// // var inserted_arr = Array.prototype.slice.call(inserted);
// // var deleted_arr = Array.prototype.slice.call(deleted);

// // console.log(inserted);
// // for (i=0; i<inserted.length; i++) {
// //  inserted[i].style.backgroundColor = "green";
// // }

// // for (i=0; i<deleted.length; i++) {
// //  deleted[i].style.backgroundColor = "pink";
// // }