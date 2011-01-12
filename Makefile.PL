use inc::Module::Install;
name 'App-Batch-ToolKit';
all_from 'lib/App/Batch/ToolKit.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
