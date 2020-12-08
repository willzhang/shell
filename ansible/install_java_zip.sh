---
- name: Check that the file exists
  stat:
    path: "{{ app_dir }}/{{ app_name }}/bin/stop.sh"
  register: stat_result

- debug: var=stat_result

# stop
- name: run stop.sh
  become: yes
  become_user: "{{ user }}"
  shell: "sh {{ app_dir }}/{{ app_name }}/bin/stop.sh"
  args:
    executable: /bin/bash
  register: app_stat
  changed_when: false
  failed_when: app_stat.rc > 0
  when: stat_result.stat.exists == True

- name: delete old directory
  file:
    path: "{{ app_dir }}/{{ app_name }}"
    state: absent

- name: Copy and unarchive zip
  become: yes
  become_user: "{{ user }}"
  unarchive:
    src: "{{ base_path }}/{{ app_name }}-{{ app_version }}.zip"
    dest: "{{ app_dir }}/"

# start
- name: start service
  become: yes
  become_user: "{{ user }}"
  shell: "sh {{ app_dir }}/{{ app_name }}/bin/start.sh"
  args:
    executable: /bin/bash
  register: app_stat
  changed_when: false
  failed_when: app_stat.rc > 0

- shell: ps -eo pid,cmd,etime,stime | grep java
  become: yes
  become_user: "{{ user }}"
  register: ps

- debug: var=ps.stdout_lines
