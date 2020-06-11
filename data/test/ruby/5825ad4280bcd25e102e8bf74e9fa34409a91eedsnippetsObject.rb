

# ExtBase Object-Param Repository
#####################################
snippet t(:extBaseObjectParamRepository) do |snip|
  snip.trigger = "extBaseObjectParamRepository"
  snip.expansion = "/**\n"
  snip.expansion+= " * ${1:product}Repository\n"
  snip.expansion+= " *\n"
  snip.expansion+= " * @var ${2:\\CodingMs\\FtmExtShop\\Domain\\Repository\\ProductRepository}\n"
  snip.expansion+= " * @inject\n"
  snip.expansion+= " */\n"
  snip.expansion+= "protected \\$${1:productRepository}Repository;\n$0"
  snip.category = "ExtBase"
end
  
  
