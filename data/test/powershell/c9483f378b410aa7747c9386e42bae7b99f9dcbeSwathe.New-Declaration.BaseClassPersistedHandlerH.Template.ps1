# 
# File: Swathe.New-Declaration.BaseClassPersistedHandlerH.Template.ps1
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


@"
/* 
 * File: $($Me.FileName)
 * 
 * Author: Akira Sugiura (urasandesu@gmail.com)
 * 
 * 
 * Copyright (c) 2014 Akira Sugiura
 *  
 *  This software is MIT License.
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */


#pragma once
#ifndef $($Me.IncludeGuard)
#define $($Me.IncludeGuard)

"@ + $({ $Me.DependentHeadersWithoutCommon } | QSelect { @"
#ifndef $($1.IncludeGuard)
#include <$($1.PathWithoutRoot)>
#endif
"@ } | QToParagraphParagraph) + @"

namespace $($Me.Namespaces[0]) { namespace $($Me.Namespaces[1]) { namespace $($Me.Function) { namespace $($Me.Category) { 

    using Urasandesu::CppAnonym::Utilities::TempPtr;
    
    template<
        class ApiHolder
    >    
    class $($Me.Name)
    {
    public:
        $($Me.ClassPersistedHandlerFacadeH.BeginTypedefAlias)
            $($Me.ClassPersistedHandlerFacadeH.DeclareTypedefAlias)
        $($Me.ClassPersistedHandlerFacadeH.EndTypedefAlias)

        typedef TempPtr<$($Me.ClassFwdH.Name.ToSnakeCase())_label_type> sender_type;

        $($Me.Name)();
        void operator()(sender_type *pSender, void *pArg);
    };

}}}}   // namespace $($Me.Namespaces[0]) { namespace $($Me.Namespaces[1]) { namespace $($Me.Function) { namespace $($Me.Category) { 

#endif  // $($Me.IncludeGuard)

"@
