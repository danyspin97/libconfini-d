project('libconfini-d', 'd', version: '1.12.0')

libconfini_c = dependency('libconfini')

install_headers('deimos/confini.d', subdir: 'd/libconfini-d')

if get_option('generate_dub_file')
    dlang = import('dlang')
    dlang.generate_dub_file(
        meson.project_name().to_lower(),
        meson.source_root(),
        authors: 'Danilo Spinella',
        description: 'D bindings for libconfini',
        copyright: 'Copyright © 2019, Danilo Spinella',
        license: 'GPL-3.0',
        sourceFiles: 'deimos/confini.d',
        targetType: 'library',
        dependencies: libconfini_c
    )
endif

pkg = import('pkgconfig')

pkg.generate(name: 'libconfini-d',
    subdirs: 'd/libconfini-d',
    version: meson.project_version(),
    description: 'D bindings for the libconfini library.',
    dependencies: libconfini_c,
)
