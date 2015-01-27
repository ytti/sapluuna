# Sapluuna

Silly little template based configuration maker

  * Anything outside {{{ ... }}} is comment and won't be in generated file
  * Inside {{{ }}} you can have <% foo %> which is just ruby
  * For method_missing in <% foo %> we try variable[name] hash, given to constrcutor, i.e. Sapluuna.new variables: {replace_this: 'with_this'} .... <% replace_this %> works
  * {{{ can be followed by negative or positive labels, if labels match to those given to constructor {{{ }}} is evaluated, otherwise ignored
  * rationale for labels is {{{ PE ..... }}}   or     {{{ Finland Sweden ..... }}} to conditionally evaluate blocks
  * You can query the instance on what variables are needed when labels X are set, use-case is in say in webUI to automatically generate form with all variables template needs

