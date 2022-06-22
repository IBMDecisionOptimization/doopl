'''This script run a DOOPL example and outputs a junit test report fragment.
'''
import argparse
import os
from os.path import join, dirname, abspath
import platform
import shutil
import subprocess
import sys
import time
import xml.etree.ElementTree as ET
from xml.dom import minidom

# assume this is in tools/
tools_dir = dirname(abspath(__file__))
project_dir = dirname(tools_dir)
target_dir = join(project_dir, 'target')
default_outdir = join(target_dir, 'reports')
examples_dir = join(project_dir, 'src', 'samples', 'examples')
lib_dir = join(project_dir, 'src', 'main', 'python')

default_opl_version = '2010'

osname = 'x86-64_linux'
if platform.system() == 'Windows':
    osname = 'x64_win64'
elif platform.system() == 'Darwin':
    osname = 'x86-64_osx'

def extend_path(path_list, path, mapping=lambda x: x):
    """Extends the specified path list with an additional path if that path
    is not already in the path list.

    Args:
        path_list: the path list
        path: the path to add. This can be an array of paths to add.
        mapping: a function to apply to path(s)
    Returns:
        Returns the extended path
    """
    # If path is a string, just add it
    if isinstance(path, str):
        if len(path_list) == 0:
            path_list = mapping(path)
        elif not (path in path_list.split(os.pathsep)):
            path_list = mapping(path) + os.pathsep + path_list
        return path_list
    # if not a string, consider it as an array
    else:
        for p in path:
            path_list = extend_path(path_list, mapping(p))
        return path_list

def update_path(env, name, path):
    new_path = extend_path(env[name], path) if name in env else extend_path([], path)
    env[name] = new_path

def str2bool(v):
    if isinstance(v, bool):
       return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Run one python program as a test")
    parser.add_argument("--outdir", metavar='OUTPUTDIRECTORY',
                        default='target',
                        help="The output directory. Default is %s" % default_outdir)
    parser.add_argument("--python", metavar='PYTHON',
                        default=None,
                        help="The python interpreter to use")
    parser.add_argument("--opl_version", metavar='OPL_VERSION',
                        default=default_opl_version,
                        help="The opl version to test against %s. Values = '2010', '2210'" % default_opl_version)
    parser.add_argument("--opl_dir", metavar='OPL_DIR',
                        default=None,
                        help="The opl directory to test against.")
    parser.add_argument("--update_path", metavar='UPDATE_PATH',
                        type=str2bool, nargs='?',
                        const=True,
                        default=False,
                        help="If true, update PATHs. Otherwise PATHs are constucted from scratch to allow clean env")
    parser.add_argument("--clean_pythonpath", metavar='CLEAN_PYTHON_PATH',
                        type=str2bool, nargs='?',
                        const=True,
                        default=False,
                        help="If true, nothing is added to pythonpath")
    parser.add_argument("program", metavar='PROGRAM',
                        nargs=argparse.REMAINDER,
                        help="Program and options")

    args, unknown_args = parser.parse_known_args()

    if args.python is None:
        python_exe = sys.executable
    else:
        python_exe = join(args.python, 'python.exe') if platform.system() == 'Windows' else join(args.python, 'bin', 'python')

    # first, get python version
    ver = subprocess.check_output([python_exe, '-c', 'import sys; print(sys.version)'])
    if isinstance(ver, bytes):
        ver = ver.decode('utf-8')
    versions = ver.replace('Python ', '').strip().split('.')
    python_version = '%s.%s' % (versions[0], versions[1])

    # command to run the test
    command = [python_exe] + args.program
    # path
    opl_distrib_bin = join(args.opl_dir, 'bin')

    path = [join(opl_distrib_bin, osname)]

    # python path
    python_path = []
    if not args.clean_pythonpath:
        python_path += [lib_dir]

    # we want a pretty clean path and pythonpath
    print('Running command: %s' % ' '.join(command))
    new_env = os.environ.copy()
    if args.update_path:
        print("Update path mode")
        update_path(new_env, 'PATH', os.pathsep.join(path))
        update_path(new_env, 'PYTHONPATH', os.pathsep.join(python_path))
        if platform.system() == 'Darwin':
            update_path(new_env, 'LD_LIBRARY_PATH', join(opl_distrib_bin, osname))
            update_path(new_env, 'DYLD_LIBRARY_PATH', join(opl_distrib_bin, osname))
        elif platform.system() == 'Linux':
            update_path(new_env, 'LD_LIBRARY_PATH', join(opl_distrib_bin, osname))
    else:
        print("Clean path mode")
        new_env.update({'PATH': os.pathsep.join(path),
                        'PYTHONPATH': os.pathsep.join(python_path)})
        if platform.system() == 'Darwin':
            new_env.update({'LD_LIBRARY_PATH': join(opl_distrib_bin, osname),
                            'DYLD_LIBRARY_PATH': join(opl_distrib_bin, osname)})
        elif platform.system() == 'Linux':
            new_env.update({'LD_LIBRARY_PATH': join(opl_distrib_bin, osname)})
    print('PYTHONPATH = %s' % new_env['PYTHONPATH'])
    if 'LD_LIBRARY_PATH' in new_env:
        print('LD_LIBRARY_PATH = %s' % new_env['LD_LIBRARY_PATH'])
    print('PATH = %s' % new_env['PATH'])
    # print(new_env)
    sys.stdout.flush()
    sys.stderr.flush()
    start = time.time()
    retcode = subprocess.call(command, cwd=examples_dir, env=new_env)
    elapsed = time.time() - start

    result = ET.Element('testsuite')
    result.set('name', ' '.join(args.program))
    result.set('tests', '1')

    testcase = ET.SubElement(result, 'testcase')
    testcase.set('name', ('_'.join(args.program)).replace('.', '_'))
    classname = '%s_opl%s.py%s.%s' % (osname,
                                      args.opl_version,
                                      python_version,
                                      ('_'.join(args.program)).replace('.', '_'))
    testcase.set('classname', classname)
    testcase.set('time', '%s' % elapsed)

    if retcode != 0:
        print('FAILED !')
        result.set('failures', '1')
        failure = ET.SubElement(testcase, 'failure')
        failure.set('message', 'ERROR')
    else:
        result.set('tests', '1')

    if not os.path.isdir(default_outdir):
        os.makedirs(default_outdir)

    with open(join(default_outdir, 'report_%s.xml' % classname), 'w') as out:
        reparsed = minidom.parseString(ET.tostring(result, 'utf-8'))
        out.write(reparsed.toprettyxml(indent="   "))

    if retcode == 0:
        exit(0)
    else:
        exit(-1)
