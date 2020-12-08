(window.webpackJsonp=window.webpackJsonp||[]).push([[8],{363:function(t,s,a){"use strict";a.r(s);var e=a(42),n=Object(e.a)({},(function(){var t=this,s=t.$createElement,a=t._self._c||s;return a("ContentSlotsDistributor",{attrs:{"slot-key":t.$parent.slotKey}},[a("h1",{attrs:{id:"bootware"}},[a("a",{staticClass:"header-anchor",attrs:{href:"#bootware"}},[t._v("#")]),t._v(" Bootware")]),t._v(" "),a("p",[a("img",{attrs:{src:"https://img.shields.io/github/repo-size/wolfgangwazzlestrauss/canvas",alt:""}}),t._v(" "),a("img",{attrs:{src:"https://img.shields.io/github/license/wolfgangwazzlestrauss/canvas",alt:""}})]),t._v(" "),a("hr"),t._v(" "),a("p",[a("strong",[t._v("Documentation")]),t._v(": https://wolfgangwazzlestrauss.github.io/bootware")]),t._v(" "),a("p",[a("strong",[t._v("Source Code")]),t._v(": https://github.com/wolfgangwazzlestrauss/bootware")]),t._v(" "),a("hr"),t._v(" "),a("p",[t._v("Bootware is a set of shell scripts and Docker images for bootstrapping software\ninstallations on a computer.")]),t._v(" "),a("h2",{attrs:{id:"install"}},[a("a",{staticClass:"header-anchor",attrs:{href:"#install"}},[t._v("#")]),t._v(" Install")]),t._v(" "),a("p",[t._v("Bootware is invoked by shell scripts on the user's computer. The following\ncommands will download the shell scripts and add them to the system path. Note\nthat on Windows, PowerShell will need to run as administrator.")]),t._v(" "),a("code-group",[a("code-block",{attrs:{title:"Linux",active:""}},[a("div",{staticClass:"language-bash extra-class"},[a("pre",{pre:!0,attrs:{class:"language-bash"}},[a("code",[a("span",{pre:!0,attrs:{class:"token function"}},[t._v("sudo")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token function"}},[t._v("curl")]),t._v(" -LSfs https://raw.githubusercontent.com/wolfgangwazzlestrauss/bootware/master/bootware.sh -o /usr/local/bin/bootware\n"),a("span",{pre:!0,attrs:{class:"token function"}},[t._v("sudo")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token function"}},[t._v("chmod")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token number"}},[t._v("755")]),t._v(" /usr/local/bin/bootware\n")])])])]),t._v(" "),a("code-block",{attrs:{title:"MacOS"}},[a("div",{staticClass:"language-bash extra-class"},[a("pre",{pre:!0,attrs:{class:"language-bash"}},[a("code",[a("span",{pre:!0,attrs:{class:"token function"}},[t._v("sudo")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token function"}},[t._v("mkdir")]),t._v(" -p /usr/local/bin/\n"),a("span",{pre:!0,attrs:{class:"token function"}},[t._v("sudo")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token function"}},[t._v("curl")]),t._v(" -LSfs https://raw.githubusercontent.com/wolfgangwazzlestrauss/bootware/master/bootware.sh -o /usr/local/bin/bootware\n"),a("span",{pre:!0,attrs:{class:"token function"}},[t._v("sudo")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token function"}},[t._v("chmod")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token number"}},[t._v("755")]),t._v(" /usr/local/bin/bootware\n"),a("span",{pre:!0,attrs:{class:"token builtin class-name"}},[t._v("echo")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token string"}},[t._v("'export PATH=\""),a("span",{pre:!0,attrs:{class:"token environment constant"}},[t._v("$PATH")]),t._v(":/usr/local/bin\"'")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v(">>")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token string"}},[t._v('"'),a("span",{pre:!0,attrs:{class:"token environment constant"}},[t._v("$HOME")]),t._v('/.profile"')]),t._v("\n"),a("span",{pre:!0,attrs:{class:"token builtin class-name"}},[t._v("export")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token assign-left variable"}},[a("span",{pre:!0,attrs:{class:"token environment constant"}},[t._v("PATH")])]),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("=")]),a("span",{pre:!0,attrs:{class:"token string"}},[t._v('"'),a("span",{pre:!0,attrs:{class:"token environment constant"}},[t._v("$PATH")]),t._v(':/usr/local/bin"')]),t._v("\n")])])])]),t._v(" "),a("code-block",{attrs:{title:"Windows"}},[a("div",{staticClass:"language-powershell extra-class"},[a("pre",{pre:!0,attrs:{class:"language-powershell"}},[a("code",[a("span",{pre:!0,attrs:{class:"token function"}},[t._v("New-Item")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("-")]),t._v("Path "),a("span",{pre:!0,attrs:{class:"token string"}},[t._v('"C:\\Program Files\\Bootware"')]),t._v(" "),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("-")]),a("span",{pre:!0,attrs:{class:"token function"}},[t._v("Type")]),t._v(" Directory\n"),a("span",{pre:!0,attrs:{class:"token variable"}},[t._v("$Env")]),t._v(":Path = "),a("span",{pre:!0,attrs:{class:"token namespace"}},[t._v("[Environment]")]),t._v("::GetEnvironmentVariable"),a("span",{pre:!0,attrs:{class:"token punctuation"}},[t._v("(")]),a("span",{pre:!0,attrs:{class:"token string"}},[t._v('"Path"')]),a("span",{pre:!0,attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token string"}},[t._v('"Machine"')]),a("span",{pre:!0,attrs:{class:"token punctuation"}},[t._v(")")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("+")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token string"}},[t._v('";C:\\Program Files\\Bootware"')]),t._v("\n"),a("span",{pre:!0,attrs:{class:"token namespace"}},[t._v("[Environment]")]),t._v("::SetEnvironmentVariable"),a("span",{pre:!0,attrs:{class:"token punctuation"}},[t._v("(")]),a("span",{pre:!0,attrs:{class:"token string"}},[t._v('"Path"')]),a("span",{pre:!0,attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token string"}},[t._v('"'),a("span",{pre:!0,attrs:{class:"token variable"}},[t._v("$Env")]),t._v(':Path"')]),a("span",{pre:!0,attrs:{class:"token punctuation"}},[t._v(",")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token string"}},[t._v('"Machine"')]),a("span",{pre:!0,attrs:{class:"token punctuation"}},[t._v(")")]),t._v("\n"),a("span",{pre:!0,attrs:{class:"token function"}},[t._v("Invoke-WebRequest")]),t._v(" "),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("-")]),t._v("Uri  https:"),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("/")]),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("/")]),t._v("raw"),a("span",{pre:!0,attrs:{class:"token punctuation"}},[t._v(".")]),t._v("githubusercontent"),a("span",{pre:!0,attrs:{class:"token punctuation"}},[t._v(".")]),t._v("com"),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("/")]),t._v("wolfgangwazzlestrauss"),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("/")]),t._v("bootware"),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("/")]),t._v("master"),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("/")]),t._v("bootware"),a("span",{pre:!0,attrs:{class:"token punctuation"}},[t._v(".")]),t._v("ps1 "),a("span",{pre:!0,attrs:{class:"token operator"}},[t._v("-")]),t._v("o "),a("span",{pre:!0,attrs:{class:"token string"}},[t._v('"C:\\Program Files\\Bootware\\bootware"')]),t._v("\n")])])])])],1),t._v(" "),a("h2",{attrs:{id:"usage"}},[a("a",{staticClass:"header-anchor",attrs:{href:"#usage"}},[t._v("#")]),t._v(" Usage")]),t._v(" "),a("p",[t._v("Bootware will bootstrap the computer software by invoking "),a("code",[t._v("bootware install")]),t._v("\nafter customizing the configuration file. To view the CLI help message, invoke\n"),a("code",[t._v("bootware --help")]),t._v(".")])],1)}),[],!1,null,null,null);s.default=n.exports}}]);