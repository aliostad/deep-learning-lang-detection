# 
# File: Swathe.New-Declaration.ClassPersistedHandlerFacadeH.Template.ps1
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

namespace $($Me.Namespaces[0]) { namespace $($Me.Namespaces[1]) { namespace $($Me.Namespaces[2]) { namespace $($Me.Function) { namespace $($Me.Category) { 

    namespace $($Me.Name)Detail {

        using namespace Urasandesu::CppAnonym;
        using namespace Urasandesu::CppAnonym::Traits;
"@ + $({ $Me.DependentHeadersWithoutCommon } | QSelect { @"
        using $($1.FullName);
"@ } | QToParagraph) + @"

        template<
            class ApiHolder
        >    
        struct $($Me.Name)Impl : 
            $($Me.ClassFacadeH.Name)<ApiHolder>
        {
"@ + $({ $Me.ClassLabelHs } | QSelect { @"
            typedef typename $($Me.ClassApiAtH.Name)<ApiHolder, $($1.Name)>::type $($1.Name.ToSnakeCase())_type;
"@ } | QToParagraph -Variable { $Me }) + @"
        };
    
    }   // namespace $($Me.Name)Detail {

    template<
        class ApiHolder
    >    
    struct $($Me.Name) : 
        $($Me.Name)Detail::$($Me.Name)Impl<ApiHolder>
    {
    };

#define $($Me.BeginTypedefAlias) \
    typedef $($Me.FullName)<ApiHolder> facade;

#define $($Me.DeclareTypedefAlias) \
    $($Me.ClassFacadeH.DeclareTypedefAlias) \
"@ + $({ $Me.ClassLabelHs } | QSelect { @"
    typedef typename facade::$($1.Name.ToSnakeCase())_type $($1.Name.ToSnakeCase())_type; \
"@ } | QToLines -Variable { $Me }) + @"
"@ + $({ $Me.ClassLabelHs } | QSelect { @"
    friend typename $($1.Name.ToSnakeCase())_type; \
"@ } | QToParagraph -Variable { $Me }) + @"

#define $($Me.EndTypedefAlias)

}}}}}   // namespace $($Me.Namespaces[0]) { namespace $($Me.Namespaces[1]) { namespace $($Me.Namespaces[2]) { namespace $($Me.Function) { namespace $($Me.Category) { 

#endif  // $($Me.IncludeGuard)

"@
