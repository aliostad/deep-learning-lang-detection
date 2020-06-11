# 
# File: Swathe.New-Declaration.Generator.EmptyHeapProvider.Template.ps1
# 
# Author: Akira Sugiura (urasandesu@gmail.com)
# 
# 
# Copyright (c) 2012 Akira Sugiura
#  
#  This software is MIT License.
#  
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#  
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#  
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.
#


$identity = $Me.ClassApiAt.TypeName.GetHashCode().ToString('x8')
@"
"@ + $({ $Me.PreviousClassLabels } | QSelect { @"
typedef typename $($Me.ClassApiAt.Name)<ApiHolder, $($1.Name)>::type $($1.Name.ToSnakeCase())_$($identity)_type;
"@ } | QToParagraphOrEmpty -Variable { $Me, $identity }) + @"

"@ + $({ $Me.PreviousClassPersistedHandlerLabels } | QSelect { @"
typedef typename $($Me.ClassApiAt.Name)<ApiHolder, $($1.Name)>::type $($1.Name.ToSnakeCase())_type;
"@ } | QToParagraphOrEmpty -Variable { $Me }) + @"

"@ + $({ $Me.PreviousClassLabels } | QZip { $Me.PreviousClassPersistedHandlerLabels } | QSelect { @"
typedef DisposingInfo<$($1[0].Name.ToSnakeCase())_$($identity)_type, $($1[1].Name.ToSnakeCase())_type> $($1[0].Name.ToSnakeCase())_disposing_info_type;
"@ } | QToParagraphOrEmpty -Variable { $Me, $identity }) + @"

"@ + $({ $Me.PreviousClassFwdHs } | QSelect { @"
typedef $($1.Name) $($1.Name.ToSnakeCase())_label_$($identity)_type;
"@ } | QToParagraphOrEmpty -Variable { $Me, $identity }) + @"

"@ + $({ $Me.PreviousClassPersistedHandlerFwdHs } | QSelect { @"
typedef $($1.Name) $($1.Name.ToSnakeCase())_label_type;
"@ } | QToParagraphOrEmpty -Variable { $Me }) + @"

"@ + $({ $Me.PreviousClassFwdHs } | QZip { $Me.PreviousClassPersistedHandlerFwdHs } | QSelect { @"
typedef DisposingInfo<$($1[0].Name.ToSnakeCase())_label_$($identity)_type, $($1[1].Name.ToSnakeCase())_label_type> $($1[0].Name.ToSnakeCase())_label_disposing_info_type;
"@ } | QToParagraphOrEmpty -Variable { $Me, $identity }) + @"

typedef Nil base_heap_provider_type;

#define $($Me.DeclareTypedefAlias) \
    typedef typename facade::base_heap_provider_type base_heap_provider_type; \
    friend typename base_heap_provider_type; \
"@ + $({ $Me.PreviousClassPersistedHandlerLabels } | QSelect { @"
    typedef typename facade::$($1.Name.ToSnakeCase())_type $($1.Name.ToSnakeCase())_type; \
"@ } | QToLinesOrEmpty -Variable { $Me }) + @"
"@ + $({ $Me.PreviousClassPersistedHandlerLabels } | QSelect { @"
    friend typename $($1.Name.ToSnakeCase())_type; \
"@ } | QToLinesOrEmpty -Variable { $Me }) + @"
"@ + $({ $Me.PreviousClassLabels } | QSelect { @"
    typedef typename facade::$($1.Name.ToSnakeCase())_disposing_info_type $($1.Name.ToSnakeCase())_disposing_info_type; \
"@ } | QToLinesOrEmpty -Variable { $Me }) + @"
"@ + $({ $Me.PreviousClassLabels } | QSelect { @"
    friend typename $($1.Name.ToSnakeCase())_disposing_info_type; \
"@ } | QToLinesOrEmpty -Variable { $Me }) + @"
"@ + $({ $Me.PreviousClassPersistedHandlerFwdHs } | QSelect { @"
    typedef typename facade::$($1.Name.ToSnakeCase())_label_type $($1.Name.ToSnakeCase())_label_type; \
"@ } | QToLinesOrEmpty -Variable { $Me }) + @"
"@ + $({ $Me.PreviousClassPersistedHandlerFwdHs } | QSelect { @"
    friend typename $($1.Name.ToSnakeCase())_label_type; \
"@ } | QToLinesOrEmpty -Variable { $Me }) + @"
"@ + $({ $Me.PreviousClassFwdHs } | QSelect { @"
    typedef typename facade::$($1.Name.ToSnakeCase())_label_disposing_info_type $($1.Name.ToSnakeCase())_label_disposing_info_type; \
"@ } | QToLinesOrEmpty -Variable { $Me }) + @"
"@ + $({ $Me.PreviousClassFwdHs } | QSelect { @"
    friend typename $($1.Name.ToSnakeCase())_label_disposing_info_type; \
"@ } | QToLinesOrEmpty -Variable { $Me }) + @"


"@
