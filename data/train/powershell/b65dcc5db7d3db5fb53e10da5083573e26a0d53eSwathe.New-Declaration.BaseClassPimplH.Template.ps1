# 
# File: Swathe.New-Declaration.BaseClassPimplH.Template.ps1
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

    using boost::aligned_storage;
    
    template<
        class ApiHolder
    >    
    class $($Me.Name)
    {
    public:
        $($Me.ClassPimplFacadeH.BeginTypedefAlias)
            $($Me.ClassPimplFacadeH.DeclareTypedefAlias)
        $($Me.ClassPimplFacadeH.EndTypedefAlias)

        $($Me.Name)($($Me.ClassFwdH.Name.ToSnakeCase())_label_type *pClass);
        ~$($Me.Name)();
        
    private:
        base_heap_provider_type *BaseHeapProvider();
        base_heap_provider_type const *BaseHeapProvider() const;
#ifdef _DEBUG
        static INT const BASE_HEAP_PROVIDER_TYPE_SIZE = 512;
#else
        static INT const BASE_HEAP_PROVIDER_TYPE_SIZE = 40;
#endif
        typedef typename aligned_storage<BASE_HEAP_PROVIDER_TYPE_SIZE>::type storage_type;
        storage_type m_storage;
        mutable $($Me.ClassFwdH.Name.ToSnakeCase())_label_type *m_pClass;
        
    };

}}}}   // namespace $($Me.Namespaces[0]) { namespace $($Me.Namespaces[1]) { namespace $($Me.Function) { namespace $($Me.Category) { 

#endif  // $($Me.IncludeGuard)

"@
